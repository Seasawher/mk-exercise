variable (P Q R : Prop)

/-- multiline `sorry` -/
example : (P → Q) → (Q → R) → (P → R) := by
  sorry

/-- various size of indent -/
example : (P → Q) → (Q → R) → (P → R) := by
  try
    sorry

/-- focusing dot -/
example : (P → Q) → (P → R) → (P → Q ∧ R) := by
  intro pq pr p
  constructor
  · sorry
  · sorry

/-- inline `sorry` -/
example : 1 + n = n + 1 := by
  calc
    1 + n = n + 1 := by sorry
    _ = n + 1 := by sorry
