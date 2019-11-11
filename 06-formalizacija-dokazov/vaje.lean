namespace hidden
universe u

-------------------------------------------------------------------------------
inductive list (A:Type) : Type
| Nil {} : list -- Brez {} moramo konstruktorju Nil vedno podati tip A
| Cons : A -> list -> list -- Cons tip A ugotovi iz tipa prvega elementa

namespace list
-- Dopolnite definicije in dokažitve trditve za sezname iz vaj 3.
-- Uporabljate -- lahko notacijo x :: xs, [] in ++ (namesto @),
-- vendar bodite pozorni na oklepaje.

notation x `::` xs := Cons x xs
notation `[]` := Nil

def join {A} : list A -> list A -> list A
| [] ys := ys
| (x::xs) ys := x :: join xs ys

notation xs `++` ys := join xs ys

theorem join_nil {A} (xs: list A) : xs ++ [] = xs :=
begin
  induction xs,
  case Nil 
    {unfold join},
  case Cons {
    unfold join,
    rewrite xs_ih,
  },
end

def reverse {A} : list A -> list A
| [] := []
| (x::xs) := (reverse xs) ++ (x::[])

theorem join_asoc {A} (xs ys zs : list A) : (xs ++ ys) ++ zs = xs ++ (ys ++ zs) :=
begin
  induction xs,
  case Nil {unfold join},
  case Cons {
    unfold join,
    rewrite xs_ih
  }
end


theorem rev_join {A} (xs ys : list A) : reverse (xs ++ ys) = (reverse ys) ++ (reverse xs) :=
begin
  induction xs,
  case Nil
    {unfold reverse, unfold join, rewrite join_nil},
  case Cons {
    unfold join,
    unfold reverse,
    rewrite xs_ih,
    apply join_asoc,
  }
end

theorem rev_invol {A} (xs : list A) : reverse (reverse xs) = xs :=
begin
  induction xs,
  unfold reverse,
  unfold reverse,
  rewrite rev_join,
  rewrite xs_ih,
  unfold reverse,
  unfold join,
end

end list
-------------------------------------------------------------------------------

-- Podobno kot za sezname, napišite tip za drevesa in dokažite trditve iz 
-- vaj 3. Če po definiciji tipa `tree` odprete `namespace tree` lahko
-- uporabljate konstruktorje brez predpone, torej `Empty` namesto
-- `tree.Empty`.

inductive tree (A:Type) : Type
| Empty {} : tree
| Node : tree -> A -> tree -> tree

namespace tree

def mirror {A}: tree A -> tree A
| Empty := Empty
| (Node lt x rt) := Node (mirror rt) x (mirror lt)

theorem mirror_invol {A} (t : tree A) : mirror (mirror t) = t :=
begin
  induction t,
  unfold mirror,
  unfold mirror,
  rewrite [t_ih_a, t_ih_a_1],
end

def tree_map {A B : Type} (f : A -> B) : tree A -> tree B
| Empty := Empty
| (Node lt x rt) := Node (tree_map lt) (f x) (tree_map rt)

theorem mirror_map_comm {A B} (t : tree A) (f : A -> B) : tree_map f (mirror t) = mirror (tree_map f t) :=
begin
  induction t,
    {unfold mirror, unfold tree_map, unfold mirror},
  case Node {
    unfold mirror,
    unfold tree_map,
    rewrite [t_ih_a, t_ih_a_1],
    unfold mirror,
  }
end

def depth {A} (t : tree A) : tree A -> nat
| Empty := 0
| (Node lt x rt) := 1 + max (depth lt) (depth rt)

end tree


-------------------------------------------------------------------------------
-- Definirajte nekaj konstruktov jezika IMP.

inductive loc : Type
| Loc : int -> loc

-- Ker v IMPu ločimo med različnimi vrstami termov, definiramo tip vrst
inductive of : Type
| AExp | BExp | Comm

namespace of

-- Tip 'term' sprejme še vrsto terma. Ukazi so tako tipa `term Comm`.
inductive tm : of -> Type
| Int : int -> tm AExp
| Plus : int -> int -> tm AExp
| Bool : bool -> tm BExp
| Eq : tm AExp -> tm AExp -> tm BExp
| Update : loc -> tm AExp -> tm Comm

theorem bullshit (t1 t2 : tm AExp) : t1 = t2 :=
begin
  cases t1,
  cases t2,
  
end


end of

end hidden