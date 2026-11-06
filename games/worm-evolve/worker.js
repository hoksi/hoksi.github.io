// One worker of 진화시키기's pool (2026-11-05, user: "웹워커와 잔손질 적용해보자"): plays whole games off the page's
// thread with the very same code (sim.js), so several cores share a generation and results equal the page's own.
self.window = self;                                          // brain.js / play.js export onto window
importScripts("brain/brain.js", "brain/play.js", "fastbrain.js?v=2", "sim.js?v=5");
onmessage = e => {
  const m = e.data;
  if (m.init) { base = m.init.base; layout = m.init.layout; template = m.init.template; G = m.init.G; return; }
  try {
    const A = makeArena(m.stage, m.seed, m.genes);
    let next = 50;
    while (!A.done) { step(A); if (A.t >= next) { postMessage({ batch: m.batch, id: m.id, t: A.t }); next += 50; } }
    // what the page needs to draw the last frame and to score / store the game
    postMessage({ batch: m.batch, id: m.id, A: { stage: A.stage, t: A.t, done: true, over: !!A.over, eaten: A.eaten, caught: A.caught, foods: A.foods, trail: A.trail,
      preds: A.preds.map(e => ({ p: e.p, shell: e.shell })), w: { p: A.w.p, armor: A.w.armor, shell: A.w.shell }, kills: A.kills || [] } });
  } catch (err) { postMessage({ batch: m.batch, id: m.id, error: String(err && err.message || err) }); }
};
