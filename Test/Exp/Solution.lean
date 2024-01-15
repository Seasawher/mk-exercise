variable (P Q R : Prop)

/-- multiline `sorry` -/
example : (P → Q) → (Q → R) → (P → R) := by
  sorry

/-- inline `sorry` -/
example : 1 + n = n + 1 := by
  calc
    1 + n = n + 1 := by sorry
    _ = n + 1 := by sorry
