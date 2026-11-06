"use strict";
// Simulation of 진화시키기, shared by the page (shown games) and worker.js (games computed in parallel):
// genes <-> brain parameters, the arena, one step, the score. Moved out of index.html on 2026-11-05 for the workers.
const EW = 236, EH = 192, HALF = 6, STEPS = 400, N = 9, STICKY = 0.1, PX = 1;
const LIVES = 3;                                            // as in the game: the 3rd catch is game over (2026-11-05)
const DXY = { 0: [0, 0], 1: [0, -1], 3: [1, 0], 5: [0, 1], 7: [-1, 0], 2: [1, -1], 4: [1, 1], 6: [-1, 1], 8: [-1, -1] };
const HEADS = [[0, -1], [1, 0], [0, 1], [-1, 0]];
const NOWALLS = new Uint8Array(EW * EH);
const STAGES = {
  heaven: { name: "먹이 천국 (포식자 없음, 먹이 76개)", preds: 0 },
  pred1:  { name: "포식자 1대", preds: 1 },
  pred2:  { name: "포식자 2대", preds: 2 },
};
const ORIGINS = {
  green:  { name: "초록 (오락실 공개 모델)", model: "pgx_bfree_k200" },
  yellow: { name: "노랑 (천국 모델)", model: "pgh_b" },
  random: { name: "무작위 (아무것도 모르는 선충)", model: null },
};
let base, layout, template, G;
const hitBox = (a, b, r = HALF + 1) => Math.abs(a[0] - b[0]) <= r && Math.abs(a[1] - b[1]) <= r;
const clamp = (v, lo, hi) => Math.min(Math.max(v, lo), hi);
const dist = (a, b) => Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]);
function rng(seed) { let a = seed >>> 0; return () => { a = (a + 0x6D2B79F5) >>> 0; let t = a; t = Math.imul(t ^ (t >>> 15), t | 1); t ^= t + Math.imul(t ^ (t >>> 7), t | 61); return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }
function gauss(r) { let u = 0, v = 0; while (!u) u = r(); while (!v) v = r(); return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v); }

// ---- genes <-> brain parameters (worm.py Brain.set_params, symmetric form, and FreeIOPlayer.set_theta)
const LO = [0.005, 0.001, 0.1], HI = [0.1, 0.03, 0.6];
function sizes() { const g = G, ni = template.Win.length * template.Win[0].length, no = template.Wout.length * template.Wout[0].length; return { g, nb: 2 * g + 3, ni, no, n: 2 * g + 3 + ni + no }; }
function decode(genes) {
  const { g, nb } = sizes(), n = base.group.length, f = Math.fround;
  const out = new Array(n), bias = new Array(n);
  for (let i = 0; i < n; i++) { const k = base.group[i]; out[i] = f(clamp(1 + genes[k], -2, 2)); bias[i] = f(clamp(0.5 * genes[g + k], -0.5, 0.5)); }
  const readout = [0, 1, 2].map(j => f(LO[j] + (HI[j] - LO[j]) * (1 + Math.tanh(genes[2 * g + j])) / 2));
  const R = template.Win.length, C = template.Win[0].length, R2 = template.Wout.length, C2 = template.Wout[0].length;
  const Win = [], Wout = [];
  for (let r = 0; r < R; r++) Win.push(Array.from(genes.subarray(nb + r * C, nb + (r + 1) * C)));
  for (let r = 0; r < R2; r++) Wout.push(Array.from(genes.subarray(nb + R * C + r * C2, nb + R * C + (r + 1) * C2)));
  return Object.assign({}, template, { out, bias, readout, Win, Wout, run: "evolve", gen: 0 });
}
function encode(p) {                                         // a public model's decoded values -> genes
  const { g, nb, n } = sizes(), genes = new Float32Array(n), seen = new Set();
  base.group.forEach((k, i) => { if (seen.has(k)) return; seen.add(k); genes[k] = p.out[i] - 1; genes[g + k] = 2 * p.bias[i]; });
  for (let j = 0; j < 3; j++) { const x = clamp(2 * (p.readout[j] - LO[j]) / (HI[j] - LO[j]) - 1, -0.999999, 0.999999); genes[2 * g + j] = Math.atanh(x); }
  genes.set(p.Win.flat(), nb); genes.set(p.Wout.flat(), nb + p.Win.length * p.Win[0].length);
  return genes;
}
function randomGenes(seed) {
  const r = rng(seed), { g, nb, n } = sizes(), genes = new Float32Array(n);
  for (let i = 0; i < n; i++) genes[i] = gauss(r) * (i < nb ? 0.1 : 0.3);
  return genes;
}
function mutate(genes, sigma, r) { const c = new Float32Array(genes.length); for (let i = 0; i < c.length; i++) c[i] = genes[i] + sigma * gauss(r); return c; }

// ---- one arena: the lab playground (food, predators that chase and shoot, reset when caught, sticky actions), seeded so all the
// worms of a generation meet exactly the same food and the same predator dice
function makeArena(stage, seed, genes) {
  const r = rng(seed), st = STAGES[stage];
  const A = { stage, r, t: 0, foods: [], preds: [], eaten: 0, caught: 0, done: false, trail: [] };
  const params = decode(genes);
  A.player = new WormPlay.WormPlayerJS(base, params);
  A.w = { p: stage === "heaven" ? layout.start.slice() : [EW / 2, EH / 2], face: [0, -1], shell: null, armor: 0, pain: null, painLeft: 0, last: null };
  if (stage === "heaven") A.foods = layout.foods.map(f => f.slice());
  else for (let k = 0; k < 20; k++) A.foods.push([12 + r() * (EW - 24), 12 + r() * (EH - 24)]);
  for (let k = 0; k < st.preds; k++) A.preds.push({ p: spot(A), face: HEADS[Math.floor(r() * 4)], shell: null, cd: 30 });
  return A;
}
function spot(A) {
  for (let k = 0; k < 200; k++) {
    const c = [HALF + 2 + A.r() * (EW - 2 * HALF - 4), HALF + 2 + A.r() * (EH - 2 * HALF - 4)];
    if (dist(c, A.w.p) >= 60) return c;
  }
  return [HALF + 2, HALF + 2];
}
// caught (a bite or a shell): as in the game, the worm is reset: it comes back at a random spot away from every
// predator with a fresh brain state, facing up, blinking invulnerable for a while. The predator stays where it is
// (a shell that hit is used up); after a crash the predator is reset too. (2026-11-05, user: "선충이 리셋되는게 맞음. 게임도 그렇게 되어 있고")
function wormSpot(A) {
  for (let k = 0; k < 200; k++) {
    const c = [HALF + 2 + A.r() * (EW - 2 * HALF - 4), HALF + 2 + A.r() * (EH - 2 * HALF - 4)];
    if (A.preds.every(e => dist(c, e.p) >= 60)) return c;
  }
  return [EW / 2, EH / 2];
}
function hurt(A, src, e) {
  const w = A.w; A.caught++; w.armor = 25;
  const shot = src === e.shell;
  if (shot) e.shell = null;
  w.p = wormSpot(A); w.face = [0, -1]; w.shell = null; w.last = null; A.trail = [];
  A.player.brain.reset(); A.player.heading = 0; A.player.turn_cd = 0;   // what the game's worm does when its tank is gone
  if (!shot) { e.p = spot(A); e.shell = null; e.cd = 30; }    // a crash resets both, as in the game ("둘 다 리셋되어야 함")
}
function step(A) {
  if (A.done) return;
  const w = A.w, r = A.r;
  const o = { player: w.p.slice(), enemies: A.preds.map(e => e.p.slice()), mines: A.foods.map(f => f.slice()), food_xy: [],
              walls: NOWALLS, fw: EW, fh: EH, shells: A.preds.filter(e => e.shell).map(e => e.shell.slice(0, 2)), score: A.eaten * 50, reserve: 1000 - A.caught };
  A.player.extra = w.painLeft > 0 ? w.pain : null; if (w.painLeft > 0) w.painLeft--;
  let a = A.player.act(o);
  if (w.last && r() < STICKY) a = w.last;
  w.last = a;
  const [dir, fire] = a, [dx, dy] = DXY[dir];
  if (dx || dy) w.face = dx && dy ? [dx, 0] : [dx, dy];
  w.p = [clamp(w.p[0] + dx * 4, HALF, EW - HALF), clamp(w.p[1] + dy * 4, HALF, EH - HALF)];
  A.trail.push(w.p.slice()); if (A.trail.length > 8) A.trail.shift();
  A.foods = A.foods.filter(f => { const e = hitBox(f, w.p); if (e) A.eaten++; return !e; });
  if (A.stage !== "heaven" && A.foods.length < 10 && A.t % 20 === 0) A.foods.push([12 + r() * (EW - 24), 12 + r() * (EH - 24)]);
  if (fire && !w.shell) w.shell = [w.p[0], w.p[1], w.face[0], w.face[1]];
  if (w.shell) {
    const sh = w.shell; sh[0] += sh[2] * 6; sh[1] += sh[3] * 6;
    const e = A.preds.find(e => hitBox(sh, e.p));
    if (sh[0] < 0 || sh[0] >= EW || sh[1] < 0 || sh[1] >= EH) w.shell = null;
    else if (e) { w.shell = null; (A.kills = A.kills || []).push({ t: A.t, p: e.p.slice() }); if (A.kills.length > 4) A.kills.shift(); e.p = spot(A); e.shell = null; e.cd = 30; }
  }
  for (const e of A.preds) {                                  // the lab's predator: chase, sometimes wander, shoot in line
    let f; const [px, py] = w.p;
    if (r() < 0.2) f = HEADS[Math.floor(r() * 4)];
    else if (Math.abs(px - e.p[0]) > Math.abs(py - e.p[1])) f = [px > e.p[0] ? 1 : -1, 0]; else f = [0, py > e.p[1] ? 1 : -1];
    e.face = f; e.p = [clamp(e.p[0] + f[0] * 2, HALF, EW - HALF), clamp(e.p[1] + f[1] * 2, HALF, EH - HALF)];
    e.cd = Math.max(0, e.cd - 1);
    if (!e.shell && e.cd === 0) {
      const ddx = w.p[0] - e.p[0], ddy = w.p[1] - e.p[1];
      const d = HEADS.find(([ax, ay]) => (ax && Math.abs(ddy) < 6 && ddx * ax > 0) || (ay && Math.abs(ddx) < 6 && ddy * ay > 0));
      if (d) { e.face = d; e.shell = [e.p[0], e.p[1], d[0], d[1]]; e.cd = 40; }
    }
    if (e.shell) { const s = e.shell; s[0] += s[2] * 6; s[1] += s[3] * 6; if (s[0] < 0 || s[0] >= EW || s[1] < 0 || s[1] >= EH) e.shell = null; }
  }
  w.armor = Math.max(0, w.armor - 1);
  if (!w.armor) for (const e of A.preds) {
    if (hitBox(w.p, e.p, 2 * HALF)) { hurt(A, e.p, e); break; }
    if (e.shell && hitBox(w.p, e.shell)) { hurt(A, e.shell, e); break; }
  }
  A.t++;
  if (A.caught >= LIVES) A.over = true;
  if (A.over || A.t >= STEPS || (A.stage === "heaven" && !A.foods.length)) A.done = true;
}
// score: food eaten (being caught costs no points, but the 3rd catch ends the game, so it costs the food not eaten);
// in heaven a cleared board also earns the steps it saved
const score = A => A.eaten + (A.stage === "heaven" && !A.foods.length ? Math.round((STEPS - A.t) / 10) : 0);

