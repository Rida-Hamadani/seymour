import Seymour.Matrix.Determinants
import Seymour.Matroid.Operations.Sum3.CanonicalSigning


/-! # Canonical signing of 3-sum of matrices -/

/-! ## Additional notation for special rows and columns -/

/-- First special column of `S.Bᵣ` used to generate `S.D`. -/
@[simp]
abbrev MatrixSum3.c₀ {Xₗ Yₗ Xᵣ Yᵣ : Type} {F : Type} (S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ F) :
    Fin 2 ⊕ Xᵣ → F :=
  ((S.D₀ᵣ ⊟ S.Dᵣ) · 0)

/-- Second special column of `S.Bᵣ` used to generate `S.D`. -/
@[simp]
abbrev MatrixSum3.c₁ {Xₗ Yₗ Xᵣ Yᵣ : Type} {F : Type} (S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ F) :
    Fin 2 ⊕ Xᵣ → F :=
  ((S.D₀ᵣ ⊟ S.Dᵣ) · 1)

/-- First special row of `S.Bₗ` used to generate `S.D`. -/
@[simp]
abbrev MatrixSum3.d₀ {Xₗ Yₗ Xᵣ Yᵣ : Type} {F : Type} (S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ F) :
    Yₗ ⊕ Fin 2 → F :=
  (S.Dₗ ◫ S.D₀ₗ) 0

/-- Second special row of `S.Bₗ` used to generate `S.D`. -/
@[simp]
abbrev MatrixSum3.d₁ {Xₗ Yₗ Xᵣ Yᵣ : Type} {F : Type} (S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ F) :
    Yₗ ⊕ Fin 2 → F :=
  (S.Dₗ ◫ S.D₀ₗ) 1


/-! ## Lemmas about extending bottom-right matrix with special rows and columns -/

lemma MatrixSum3.HasTuBᵣ_special_form_cols {Xₗ Yₗ Xᵣ Yᵣ : Type} {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.HasTuBᵣ) :
    ∀ i : Fin 2 ⊕ Xᵣ, ![S.c₀ i, S.c₁ i] ≠ ![1, -1] ∧ ![S.c₀ i, S.c₁ i] ≠ ![-1, 1] := by
  intro i
  have := hS.det ![◪i, ◩0] ![◩0, ◩1]
  constructor
  <;> intro contr
  <;> have := congr_fun contr 0
  <;> have := congr_fun contr 1
  <;> simp_all [Matrix.det_fin_two]

lemma MatrixSum3.HasTuBᵣ.c₀_c₂_Aᵣ_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ] {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.HasTuBᵣ) :
    (▮S.c₀ ◫ ▮(S.c₀ - S.c₁) ◫ S.Aᵣ).IsTotallyUnimodular := by
  let B : Matrix (Fin 1 ⊕ (Fin 2 ⊕ Xᵣ)) (Fin 2 ⊕ (Fin 1 ⊕ Yᵣ)) ℚ := S.Bᵣ.shortTableauPivot ◩0 ◩0
  let B' : Matrix (Fin 2 ⊕ Xᵣ) (Fin 2 ⊕ (Fin 1 ⊕ Yᵣ)) ℚ := B.submatrix Sum.inr id
  have B'_eq : B' = (▮(-S.c₀) ◫ ▮(S.c₁ - S.c₀) ◫ S.Aᵣ).submatrix id equivUnitSumUnit.leftCongr.symm
  · ext _ (j₂ | _)
    · fin_cases j₂ <;> simp [Matrix.shortTableauPivot_eq, B, B']
    · simp [Matrix.shortTableauPivot_eq, B, B']
  have hB : B.IsTotallyUnimodular
  · apply hS.shortTableauPivot
    simp [MatrixSum3.Bᵣ]
  have hB' : B'.IsTotallyUnimodular
  · apply hB.submatrix
  rw [B'_eq] at hB'
  have hScc : (▮(-S.c₀) ◫ ▮(S.c₁ - S.c₀) ◫ S.Aᵣ).IsTotallyUnimodular
  · simpa only [Matrix.submatrix_submatrix, Equiv.symm_comp_self, Function.comp_id, Matrix.submatrix_id_id] using
      hB'.submatrix id equivUnitSumUnit.leftCongr
  let q : (Unit ⊕ Unit) ⊕ (Fin 1 ⊕ Yᵣ) → ℚ := (·.casesOn (-1) 1)
  have hq : ∀ i : (Unit ⊕ Unit) ⊕ (Fin 1 ⊕ Yᵣ), q i ∈ SignType.cast.range
  · rintro (_|_) <;> simp [q]
  convert hScc.mul_cols hq
  ext _ ((_|_)|_) <;> simp [q]

lemma MatrixSum3.HasTuBᵣ.c₂_c₁_Aᵣ_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ] {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.HasTuBᵣ) :
    (▮(S.c₀ - S.c₁) ◫ ▮S.c₁ ◫ S.Aᵣ).IsTotallyUnimodular := by
  let B : Matrix (Fin 1 ⊕ (Fin 2 ⊕ Xᵣ)) (Fin 2 ⊕ (Fin 1 ⊕ Yᵣ)) ℚ := S.Bᵣ.shortTableauPivot ◩0 ◩1
  let B' : Matrix (Fin 2 ⊕ Xᵣ) (Fin 2 ⊕ (Fin 1 ⊕ Yᵣ)) ℚ := B.submatrix Sum.inr id
  have B'_eq : B' = (▮(S.c₀ - S.c₁) ◫ ▮(-S.c₁) ◫ S.Aᵣ).submatrix id equivUnitSumUnit.leftCongr.symm
  · ext _ (j₂ | _)
    · fin_cases j₂ <;> simp [Matrix.shortTableauPivot_eq, B, B']
    · simp [Matrix.shortTableauPivot_eq, B, B']
  have hB : B.IsTotallyUnimodular
  · apply hS.shortTableauPivot
    simp [MatrixSum3.Bᵣ]
  have hB' : B'.IsTotallyUnimodular
  · apply hB.submatrix
  rw [B'_eq] at hB'
  have hScc : (▮(S.c₀ - S.c₁) ◫ ▮(-S.c₁) ◫ S.Aᵣ).IsTotallyUnimodular
  · simpa only [Matrix.submatrix_submatrix, Equiv.symm_comp_self, Function.comp_id, Matrix.submatrix_id_id] using
      hB'.submatrix id equivUnitSumUnit.leftCongr
  let q : (Unit ⊕ Unit) ⊕ (Fin 1 ⊕ Yᵣ) → ℚ := (·.casesOn (·.casesOn 1 (-1)) 1)
  have hq : ∀ i : (Unit ⊕ Unit) ⊕ (Fin 1 ⊕ Yᵣ), q i ∈ SignType.cast.range
  · rintro ((_|_)|_) <;> simp [q]
  convert hScc.mul_cols hq
  ext _ ((_|_)|_) <;> simp [q]

lemma MatrixSum3.HasTuBᵣ.c₀_c₁_c₂_Aᵣ_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ] {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.HasTuBᵣ) :
    (▮S.c₀ ◫ ▮S.c₁ ◫ ▮(S.c₀ - S.c₁) ◫ S.Aᵣ).IsTotallyUnimodular := by
  intro k f g hf hg
  -- Is `c₂` contained in the submatrix?
  if hgc₂ : ∃ j, g j = ◩◪() then
    obtain ⟨j₂, hj₂⟩ := hgc₂
    -- Is `c₀` contained in the submatrix?
    if hgc₀ : ∃ j, g j = ◩◩◩() then
      obtain ⟨j₀, hj₀⟩ := hgc₀
      -- Is `c₁` contained in the submatrix?
      if hgc₁ : ∃ j, g j = ◩◩◪() then
        obtain ⟨j₁, hj₁⟩ := hgc₁
        use 0
        symm
        apply ((▮S.c₀ ◫ ▮S.c₁ ◫ ▮(S.c₀ - S.c₁) ◫ S.Aᵣ).submatrix f g).det_eq_zero_of_col_sub_col_eq_col j₀ j₁ j₂
        simp [hj₀, hj₁, hj₂]
        rfl
      else
        convert hS.c₀_c₂_Aᵣ_isTotallyUnimodular.det f ((·.map (·.casesOn (·.casesOn Sum.inl Sum.inl) Sum.inr) id) ∘ g)
        ext i j
        cases hgj : g j with
        | inl z₃ => cases z₃ with
          | inl z₂ =>
            cases z₂ with
            | inl => simp [hgj]
            | inr => tauto
          | inr => simp [*]
        | inr z₁ => cases z₁ <;> simp [hgj]
    else
      convert hS.c₂_c₁_Aᵣ_isTotallyUnimodular.det f ((·.map (·.casesOn (·.casesOn Sum.inr Sum.inr) Sum.inl) id) ∘ g)
      ext i j
      cases hgj : g j with
      | inl z₃ => cases z₃ with
        | inl z₂ =>
          cases z₂ with
          | inl => tauto
          | inr => simp [hgj]
        | inr => simp [*]
      | inr z₁ => cases z₁ <;> simp [hgj]
  else
    -- Here we have a submatrix of the original matrix.
    let f' : Fin k → Fin 1 ⊕ (Fin 2 ⊕ Xᵣ) := Sum.inr ∘ f
    let g' : Fin k → Fin 2 ⊕ (Fin 1 ⊕ Yᵣ) := (·.map (·.casesOn equivUnitSumUnit ↓0) id) ∘ g
    convert hS.det f' g'
    ext i j
    cases hgj : g j with
    | inl z₃ => cases z₃ with
      | inl z₂ => cases z₂ <;> simp [hgj, f', g']
      | inr => tauto
    | inr z₁ => cases z₁ <;> simp [hgj, f', g']

lemma MatrixSum3.HasTuBᵣ.c₀_c₀_c₁_c₁_c₂_c₂_Aᵣ_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ] {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.HasTuBᵣ) :
    (▮S.c₀ ◫ ▮S.c₀ ◫ ▮S.c₁ ◫ ▮S.c₁ ◫ ▮(S.c₀ - S.c₁) ◫ ▮(S.c₀ - S.c₁) ◫ S.Aᵣ).IsTotallyUnimodular := by
  convert hS.c₀_c₁_c₂_Aᵣ_isTotallyUnimodular.comp_cols
    (fun j : ((((((Unit ⊕ Unit) ⊕ Unit) ⊕ Unit) ⊕ Unit) ⊕ Unit) ⊕ (Fin 1 ⊕ Yᵣ)) =>
      (j.casesOn (·.casesOn (·.casesOn (·.casesOn (·.casesOn (·.casesOn (↓◩◩◩()) ↓◩◩◩()) ↓◩◩◪()) ↓◩◩◪()) ↓◩◪()) ↓◩◪()) Sum.inr))
  aesop

lemma MatrixSum3.HasTuBᵣ.pmz_c₀_c₁_c₂_Aᵣ_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ] {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.HasTuBᵣ) :
    (▮0 ◫ (▮S.c₀ ◫ ▮(-S.c₀) ◫ ▮S.c₁ ◫ ▮(-S.c₁) ◫ ▮(S.c₀ - S.c₁) ◫ ▮(S.c₁ - S.c₀) ◫ S.Aᵣ)).IsTotallyUnimodular := by
  convert (hS.c₀_c₀_c₁_c₁_c₂_c₂_Aᵣ_isTotallyUnimodular.mul_cols
    (show ∀ j, (·.casesOn (·.casesOn (·.casesOn (·.casesOn (·.casesOn (·.casesOn 1 (-1)) 1) (-1)) 1) (-1)) 1) j ∈
        SignType.cast.range by rintro ((((((_|_)|_)|_)|_)|_)|_) <;> simp)).zero_fromCols Unit
  aesop

lemma MatrixSum3.HasTuBₗ.pmz_d₀_d₁_d₂_Aₗ_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ] {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.HasTuBₗ) :
    (▬0 ⊟ (▬S.d₀ ⊟ ▬(-S.d₀) ⊟ ▬S.d₁ ⊟ ▬(-S.d₁) ⊟ ▬(S.d₀ - S.d₁) ⊟ ▬(S.d₁ - S.d₀) ⊟ S.Aₗ)).IsTotallyUnimodular := by
  have hS' : S.transpose.HasTuBᵣ
  · simp only [MatrixSum3.HasTuBₗ, MatrixSum3.Bₗ] at hS
    simp only [MatrixSum3.HasTuBᵣ, MatrixSum3.Bᵣ, MatrixSum3.transpose]
    convert hS.transpose.submatrix (Sum.map Sum.swap id ∘ Sum.swap) (Sum.map Sum.swap id ∘ Sum.swap)
    ext (_|_|_) (j | _)
    · fin_cases j <;> simp
    all_goals simp
  rw [←Matrix.transpose_isTotallyUnimodular_iff]
  convert hS'.pmz_c₀_c₁_c₂_Aᵣ_isTotallyUnimodular.submatrix Sum.swap (Sum.map id (Sum.map id Sum.swap))
  aesop


/-! ## Definition -/

/-- Canonical re-signing of a 3-sum of matrices over `Z2`. -/
noncomputable def MatrixSum3.toCanonicalSigning {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ]
    (S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ Z2) (hSₗ : S.Bₗ.HasTuSigning) (hSᵣ : S.Bᵣ.HasTuSigning) :
    MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ :=
  MatrixSum3.fromBlockSummands
    (hSₗ.choose.toCanonicalSigning ◪0 ◪1 ◩◪0 ◩◪0 ◩◪1 ◪0)
    (hSᵣ.choose.toCanonicalSigning ◪◩0 ◪◩1 ◩0 ◩0 ◩1 ◪◩0)

/-- Proposition that `S` is a canonical signing of a 3-sum of matrices. -/
def MatrixSum3.IsCanonicalSigning {Xₗ Yₗ Xᵣ Yᵣ : Type} (S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ) : Prop :=
  (S.Bₗ.IsTotallyUnimodular ∧ S.Bᵣ.IsTotallyUnimodular) ∧
    ((S.Sₗ = matrix3x3signed₀ ∧ S.Sᵣ = matrix3x3signed₀) ∨
     (S.Sₗ = matrix3x3signed₁ ∧ S.Sᵣ = matrix3x3signed₁))

/-- Sufficient condition for existence of a canonical signing of a 3-sum of matrices over `Z2`. -/
def MatrixSum3.HasCanonicalSigning {Xₗ Yₗ Xᵣ Yᵣ : Type} (S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ Z2) : Prop :=
  (S.Bₗ.HasTuSigning ∧ S.Bᵣ.HasTuSigning) ∧
    ((S.Sₗ = matrix3x3unsigned₀ Z2 ∧ S.Sᵣ = matrix3x3unsigned₀ Z2) ∨
     (S.Sₗ = matrix3x3unsigned₁ Z2 ∧ S.Sᵣ = matrix3x3unsigned₁ Z2))


/-! ## Correctness -/

/-- Canonical re-signing transforms a 3-sum of matrices into its canonically signed version. -/
lemma MatrixSum3.HasCanonicalSigning.isCanonicalSigning {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ]
    {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ Z2} (hS : S.HasCanonicalSigning) :
    (S.toCanonicalSigning hS.left.left hS.left.right).IsCanonicalSigning :=
  sorry -- Ivan is working on this.

/-- Canonical re-signing yields a signing of the original 3-sum of marices. -/
lemma MatrixSum3.HasCanonicalSigning.toCanonicalSigning {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ]
    {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ Z2} (hS : S.HasCanonicalSigning) :
    (S.toCanonicalSigning hS.left.left hS.left.right).matrix.IsSigningOf S.matrix :=
  sorry -- Ivan is working on this.


/-! ## Properties -/

abbrev VecIsParallel3 {X F : Type} [Zero F] [Neg F] (v : X → F) (c₀ c₁ c₂ : X → F) : Prop :=
  v = 0 ∨ v = c₀ ∨ v = -c₀ ∨ v = c₁ ∨ v = -c₁ ∨ v = c₂ ∨ v = -c₂

lemma VecIsParallel3.neg {X F : Type} [Field F] {v : X → F} {c₀ c₁ c₂ : X → F}
    (hv : VecIsParallel3 v c₀ c₁ c₂) :
    VecIsParallel3 (-v) c₀ c₁ c₂ := by
  rcases hv with (hv | hv | hv | hv | hv | hv | hv)
  all_goals
    rw [hv]
    ring_nf
    simp only [VecIsParallel3, true_or, or_true]

lemma VecIsParallel3.mul_sign {X F : Type} [Field F] {v : X → F} {c₀ c₁ c₂ : X → F}
    (hv : VecIsParallel3 v c₀ c₁ c₂) {q : F} (hq : q ∈ SignType.cast.range) :
    VecIsParallel3 (fun i : X => v i * q) c₀ c₁ c₂ := by
  obtain ⟨s, hs⟩ := hq
  cases s with
  | zero =>
    simp only [SignType.zero_eq_zero, SignType.coe_zero] at hs
    simp only [←hs, mul_zero]
    left
    rfl
  | pos =>
    simp only [SignType.pos_eq_one, SignType.coe_one] at hs
    simp [←hs]
    exact hv
  | neg =>
    simp only [SignType.neg_eq_neg_one, SignType.coe_neg, SignType.coe_one] at hs
    simp only [←hs, mul_neg, mul_one]
    exact hv.neg

/-- The bottom-left block of a canonical signing of a 3-sum of matrices in the first special case. -/
lemma MatrixSum3.IsCanonicalSigning.D_eq_sum_outer₀ {Xₗ Yₗ Xᵣ Yᵣ : Type} {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.IsCanonicalSigning) (hS₀ : S.Sₗ = matrix3x3signed₀) :
    S.D = S.c₀ ⊗ S.d₀ - S.c₁ ⊗ S.d₁ :=
  sorry

/-- The bottom-left block of a canonical signing of a 3-sum of matrices in the second special case. -/
lemma MatrixSum3.IsCanonicalSigning.D_eq_sum_outer₁ {Xₗ Yₗ Xᵣ Yᵣ : Type} {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.IsCanonicalSigning) (hS₁ : S.Sₗ = matrix3x3signed₁) :
    S.D = S.c₀ ⊗ S.d₀ - S.c₀ ⊗ S.d₁ + S.c₁ ⊗ S.d₁ :=
  sorry

/-- Every col of the bottom-left block of a canonical signing of a 3-sum of matrices is in `{0, ±c₀, ±c₁, ±c₂}`. -/
lemma MatrixSum3.IsCanonicalSigning.D_eq_cols {Xₗ Yₗ Xᵣ Yᵣ : Type} {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.IsCanonicalSigning) :
    ∀ j : Yₗ ⊕ Fin 2, VecIsParallel3 (S.D · j) S.c₀ S.c₁ (S.c₀ - S.c₁) :=
  sorry

/-- Every row of the bottom-left block of a canonical signing of a 3-sum of matrices is in `{0, ±d₀, ±d₁, ±d₂}`. -/
lemma MatrixSum3.IsCanonicalSigning.D_eq_rows {Xₗ Yₗ Xᵣ Yᵣ : Type} {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    (hS : S.IsCanonicalSigning) :
    ∀ i : Fin 2 ⊕ Xᵣ, VecIsParallel3 (S.D i) S.d₀ S.d₁ (S.d₀ - S.d₁) :=
  sorry

/-- The left block of a canonical signing of a 3-sum of matrices is totally unimodular. -/
lemma MatrixSum3.IsCanonicalSigning.Aₗ_D_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type} {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ]
    (hS : S.IsCanonicalSigning) :

    (S.Aₗ ⊟ S.D).IsTotallyUnimodular := by
  classical
  let e : ((Xₗ ⊕ Fin 1) ⊕ Fin 2 ⊕ Xᵣ →
      (Unit ⊕ (((((Unit ⊕ Unit) ⊕ Unit) ⊕ Unit) ⊕ Unit) ⊕ Unit) ⊕ Xₗ ⊕ Fin 1)) :=
    (·.casesOn
      (Sum.inr ∘ Sum.inr)
      fun j ↦
        if h0 : S.D j = 0 then ◩() else
        if hpc₀ : S.D j = S.d₀ then ◪◩◩◩◩◩◩() else
        if hmc₀ : S.D j = -S.d₀ then ◪◩◩◩◩◩◪() else
        if hpc₁ : S.D j = S.d₁ then ◪◩◩◩◩◪() else
        if hmc₁ : S.D j = -S.d₁ then ◪◩◩◩◪() else
        if hpc₂ : S.D j = S.d₀ - S.d₁ then ◪◩◩◪() else
        if hmc₂ : S.D j = S.d₁ - S.d₀ then ◪◩◪() else
        False.elim (have := hS.D_eq_rows j; by aesop))
  convert (MatrixSum3.HasTuBₗ.pmz_d₀_d₁_d₂_Aₗ_isTotallyUnimodular hS.1.1).submatrix e id
  ext i j
  cases i with
  | inl => rfl
  | inr i =>
    simp only [Matrix.fromRows_apply_inr, Matrix.replicateRow_zero, Fin.isValue, Matrix.submatrix_apply, id_eq]
    wlog h0 : ¬ S.D i = 0
    · rw [not_not] at h0
      simp [e, h0, congr_fun h0 j]
    wlog hpd₀ : ¬ S.D i = S.d₀
    · rw [not_not] at hpd₀
      simp only [e, h0]
      simp [hpd₀, congr_fun hpd₀ j]
    wlog hmd₀ : ¬ S.D i = -S.d₀
    · rw [not_not] at hmd₀
      simp only [e, h0, hpd₀]
      simp [hmd₀, congr_fun hmd₀ j]
    wlog hpd₁ : ¬ S.D i = S.d₁
    · rw [not_not] at hpd₁
      simp only [e, h0, hpd₀, hmd₀]
      simp [hpd₁, congr_fun hpd₁ j]
    wlog hmd₁ : ¬ S.D i = -S.d₁
    · rw [not_not] at hmd₁
      simp only [e, h0, hpd₀, hmd₀, hpd₁]
      simp [hmd₁, congr_fun hmd₁ j]
    wlog hpd₂ : ¬ S.D i = S.d₀ - S.d₁
    · rw [not_not] at hpd₂
      simp only [e, h0, hpd₀, hmd₀, hpd₁, hmd₁]
      simp [hpd₂, congr_fun hpd₂ j]
    wlog hmd₂ : ¬ S.D i = S.d₁ - S.d₀
    · rw [not_not] at hmd₂
      simp only [e, h0, hpd₀, hmd₀, hpd₁, hmd₁, hpd₂]
      simp [hmd₂, congr_fun hmd₂ j]
    exfalso
    have h := hS.D_eq_rows i
    rw [VecIsParallel3, neg_sub S.d₀ S.d₁] at h
    tauto

/-- The extension of the bottom-right block of a canonical signing of a 3-sum of matrices with special columns is totally
    unimodular. -/
lemma MatrixSum3.IsCanonicalSigning.c₀_c₁_c₂_Aᵣ_isTotallyUnimodular {Xₗ Yₗ Xᵣ Yᵣ : Type}
    [DecidableEq Xₗ] [DecidableEq Yₗ] [DecidableEq Xᵣ] [DecidableEq Yᵣ]
    {S : MatrixSum3 Xₗ Yₗ Xᵣ Yᵣ ℚ} (hS : S.IsCanonicalSigning) :
    (▮S.c₀ ◫ ▮S.c₁ ◫ ▮(S.c₀ - S.c₁) ◫ S.Aᵣ).IsTotallyUnimodular :=
  MatrixSum3.HasTuBᵣ.c₀_c₁_c₂_Aᵣ_isTotallyUnimodular hS.left.right
