variable (P Q R : Prop)

/-- multiline `sorry` -/
example : (P → Q) → (Q → R) → (P → R) := by
  -- sorry
  intro pq qr pr
  exact qr (pq pr)
  -- sorry

/-- various size of indent -/
example : (P → Q) → (Q → R) → (P → R) := by
  try
    -- sorry
    intro pq qr pr
    exact qr (pq pr)
    -- sorry

/-- inline `sorry` -/
example : 1 + n = n + 1 := by
  calc
    1 + n = n + 1 := by /- sorry -/ rw [Nat.add_comm]
    _ = n + 1 := by /- sorry -/ rfl
