import «Lean 4  Attempt 01»
import Std

def main : IO Unit :=
  IO.println s!"Hello, {hello}!"


-- Import the standard library (Std) which brings in many basic definitions and tactics.


/-
Define a function `add` which takes two natural numbers `a` and `b` and computes their sum.
Here we use pattern matching on `b`. Note that Lean’s built-in natural numbers already have an addition,
but this is for demonstration.
-/
def add (a b : Nat) : Nat :=
  match b with
  | 0     => a
  | b + 1 => (add a b) + 1

-- We can evaluate the function using the `#eval` command.
#eval add 3 4  -- Expected output: 7



universe u



variable {X : Type u}
variable (pref : X → X → Prop)

------------------------------------------------------------
-- Axioms on Preferences
------------------------------------------------------------

/-- Completeness: For every x and y, either x is at least as good as y or vice versa. -/
def complete (pref : X → X → Prop) : Prop :=
  ∀ x y : X, pref x y ∨ pref y x

/-- Transitivity: If x is at least as good as y and y is at least as good as z, then x is at least as good as z. -/
def transitive (pref : X → X → Prop) : Prop :=
  ∀ x y z : X, pref x y → pref y z → pref x z

------------------------------------------------------------
-- Derived Notions
------------------------------------------------------------

/-- Strict preference: x is strictly preferred to y if pref x y holds and pref y x does not. -/
def strict (x y : X) : Prop :=
  pref x y ∧ ¬ pref y x

/-- Indifference: x and y are indifferent if each is at least as good as the other. -/
def indifferent (x y : X) : Prop :=
  pref x y ∧ pref y x

------------------------------------------------------------
-- Theorems about Preferences
------------------------------------------------------------

/-- Theorem: Strict preference is asymmetric.
    That is, if x is strictly preferred to y, then y cannot be strictly preferred to x. -/
theorem strict_asymmetric {x y : X} (h : strict pref x y) : ¬ strict pref y x :=
begin
  intro hxy,
  -- h: pref x y ∧ ¬ pref y x; hxy: pref y x ∧ ¬ pref x y.
  exact h.right hxy.left,
end

/-- Theorem (Preference Trichotomy):
    If pref is complete, then for any x and y,
    either x and y are indifferent,
    or x is strictly preferred to y,
    or y is strictly preferred to x. -/
theorem preference_trichotomy (hcomp : complete pref) (x y : X) :
  indifferent pref x y ∨ strict pref x y ∨ strict pref y x :=
begin
  have h := hcomp x y,
  cases h with hxy hyx,
  { by_cases h' : pref y x,
    { left, exact ⟨hxy, h'⟩ },
    { right, left, exact ⟨hxy, h'⟩ } },
  { by_cases h' : pref x y,
    { left, exact ⟨h', hyx⟩ },
    { right, right, exact ⟨hyx, h'⟩ } }
end
