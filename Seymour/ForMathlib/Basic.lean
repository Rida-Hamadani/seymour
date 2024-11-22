import Mathlib.Tactic

@[simp]
def Function.myEquiv {α β₁ β₂ : Type*} (f : α → β₁ ⊕ β₂) :
    α ≃ { x₁ : α × β₁ // f x₁.fst = Sum.inl x₁.snd } ⊕ { x₂ : α × β₂ // f x₂.fst = Sum.inr x₂.snd } where
  toFun a :=
    (match hfa : f a with
      | .inl b₁ => Sum.inl ⟨(a, b₁), hfa⟩
      | .inr b₂ => Sum.inr ⟨(a, b₂), hfa⟩
    )
  invFun x :=
    x.casesOn (·.val.fst) (·.val.fst)
  left_inv a := by
    match hfa : f a with
    | .inl b₁ => aesop
    | .inr b₂ => aesop
  right_inv x := by
    cases x with
    | inl => aesop
    | inr => aesop

lemma Function.eq_comp_myEquiv {α β₁ β₂ : Type*} (f : α → β₁ ⊕ β₂) :
    f = Sum.elim (Sum.inl ∘ (·.val.snd)) (Sum.inr ∘ (·.val.snd)) ∘ myEquiv f := by
  aesop

lemma zom_mul_zom {R : Type*} [Ring R] {x y : R}
    (hx : x = 0 ∨ x = 1 ∨ x = -1) (hy : y = 0 ∨ y = 1 ∨ y = -1) :
    x*y = 0 ∨ x*y = 1 ∨ x*y = -1 := by
  aesop