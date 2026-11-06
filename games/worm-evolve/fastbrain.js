// Faster WormBrain.step for 진화시키기 (2026-11-05, user: "웹워커와 잔손질 적용해보자"). Same float32 arithmetic in the
// same order as brain/brain.js (results are bit-identical), but: buffers reused instead of allocated every step, fields
// read once into locals, the CSR row end cached. brain/brain.js itself is left as it is (it is synced from worm-arcade).
(function () {
  const f = Math.fround, B = (typeof WormBrain !== "undefined" ? WormBrain : self.WormBrain).prototype, orig = B.step;
  const F03 = f(0.3), F005 = f(0.05);
  B.step = function (inputs = {}) {
    if (!(inputs instanceof Float32Array)) return orig.call(this, inputs);
    const n = this.n;
    if (!this._W) this._build();
    if (!this._buf || this._buf.n !== n) this._buf = { n, drive: new Float32Array(n), nv: new Float32Array(n) };
    const I = inputs, { ptr, col, val } = this._W, K = f(this.K), TH = f(this.TH), AD = f(this.ADAPT);
    const drive = this._buf.drive, nv = this._buf.nv, bias = this.bias, u = this.u, a = this.v, subs = this.substeps;
    for (let s = 0; s < subs; s++) {
      for (let t = 0, k = 0; t < n; t++) {
        let acc = 0; const end = ptr[t + 1];
        for (k = ptr[t]; k < end; k++) acc = f(acc + f(val[k] * a[col[k]]));
        drive[t] = acc;
      }
      for (let t = 0; t < n; t++) {
        let x = f(f(f(f(f(K * drive[t]) + bias[t]) + I[t]) - TH) - f(AD * u[t]));
        x = f(Math.tanh(x));
        const at = a[t];
        nv[t] = f(at + f(F03 * f(-at + (x > 0 ? x : 0))));
      }
      for (let t = 0; t < n; t++) u[t] = f(u[t] + f(F005 * f(nv[t] - u[t])));
      a.set(nv);
    }
    const m = {};
    for (const k in this.motors) { const ids = this.motors[k]; let acc = 0; for (let j = 0; j < ids.length; j++) acc += a[ids[j]]; m[k] = ids.length ? acc / ids.length : 0; }
    return m;
  };
  B.stepSlow = orig;
})();
