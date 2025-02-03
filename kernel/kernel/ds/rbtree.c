#include <ds/rbtree.h>

static inline void rotate_right(struct rbtree* tree, struct rb_node* node) {
  struct rb_node *x = node;
  struct rb_node *y = x -> left;

  x -> left = y -> right;
  if (y -> right != NULL) {
    struct rb_node* yr = y -> right;
    rb_set_parent(yr, x);
  }

  rb_set_parent(y, rb_parent(x));

  if (rb_parent(x) == NULL) tree -> root = y;
  else {
    struct rb_node* xp = rb_parent(x);
    if (x == xp -> left) xp -> left = y;
    else xp -> right = y;
  }
  y -> right = x;
  rb_set_parent(x, y);
}

static inline void rotate_left(struct rbtree* tree, struct rb_node* node) {
  struct rb_node *x = node;
  struct rb_node *y = x -> right;

  x -> right = y -> left;
  if (y -> left != NULL) {
    struct rb_node* yl = y -> left;
    rb_set_parent(yl, x);
  }

  rb_set_parent(y, rb_parent(x));

  if (rb_parent(x) == NULL) tree -> root = y;
  else {
    struct rb_node* xp = rb_parent(x);
    if (x == xp -> left) xp -> left = y;
    else xp -> right = y;
  }
  y -> left = x;
  rb_set_parent(x, y);
}

static inline void insert_case1(struct rbtree* tree, struct rb_node* node) {
  rb_set_color(node, RB_BLACK);
  tree -> root = node;
}

static inline void insert_case2(struct rbtree* tree, struct rb_node* node) {
  (void) node;
  (void) tree;
}

static inline struct rb_node* insert_case3(struct rbtree* tree, struct rb_node* node) {
  rb_set_color(rb_parent(node), RB_BLACK);
  rb_set_color(rb_uncle(node), RB_BLACK);
  rb_set_color(rb_grandparent(node), RB_RED);
  (void) tree;
  return rb_grandparent(node);
}

static inline void insert_case4(struct rbtree* tree, struct rb_node* node) {
  struct rb_node* parent = rb_parent(node), * grandparent = rb_grandparent(node);
  if (grandparent -> left && node == grandparent -> left -> right) {
    rotate_left(tree, parent);
    node = node -> left;
  } else if (grandparent -> right && node == grandparent -> right -> left) {
    rotate_right(tree, parent);
    node = node -> right;
  }

  parent = rb_parent(node);
  grandparent = rb_grandparent(node);

  if (node == parent -> left) rotate_right(tree, grandparent);
  else rotate_left(tree, grandparent);

  rb_set_color(parent, RB_BLACK);
  rb_set_color(grandparent, RB_RED);
}

void rb_insert(struct rbtree* tree, struct rb_node* node, bool most_left) {
  if (node == NULL) return;
  struct rb_node* original = node;

  while (1) {
    struct rb_node* parent = rb_parent(node);
    if (parent == NULL) {
      insert_case1(tree, node);
      break;
    } else if (rb_color(parent) == RB_BLACK) {
      insert_case2(tree, node);
      break;
    } else if (rb_color(rb_uncle(node)) == RB_RED) {
      node = insert_case3(tree, node);
    } else {
      insert_case4(tree, node);
      break;
    }
  }
  if (most_left && original -> left == NULL) tree -> most_left = original;
}

static inline void rb_swap(struct rbtree* tree, struct rb_node* x, struct rb_node* y) {
  struct rb_node* left = x -> left;
  struct rb_node* right = x -> right;
  struct rb_node* parent = rb_parent(x);

  rb_set_parent(y, parent);

  if (parent != NULL) {
    if (parent -> left == x) parent -> left = y;
    else parent -> right = y;
  } else {
    if (tree -> root == x) tree -> root = y;
  }

  y -> right = right;
  if (right != NULL) rb_set_parent(right, y);
  x -> right = NULL;
  y -> left = left;
  if (left != NULL) rb_set_parent(left, y);
  x -> left = NULL;
  rb_set_color(y, rb_color(x));
  rb_set_parent(x, NULL);
}

void rb_replace(struct rbtree* tree, struct rb_node* victim, struct rb_node* target) {
  *target = *victim;

  if (target -> left) rb_set_parent(target -> left, target);
  if (target -> right) rb_set_parent(target -> right, target);

  if (victim == tree -> root) tree -> root = target;
}

static inline void erase_parent_link(struct rbtree* tree, struct rb_node* node, struct rb_node* replacement) {
  struct rb_node* parent = rb_parent(node);
  if (parent == NULL) tree -> root = replacement;
  else if (parent -> left == node) parent -> left = replacement;
  else if (parent -> right == node) parent -> right = replacement;
}

static inline void erase_rebalance(struct rbtree* tree, struct rb_node* node, struct rb_node* parent, bool node_is_left) {
  struct rb_node* x = node;
  struct rb_node* xp = parent;
  int is_left = node_is_left;

  while (x != tree -> root && (x == NULL || rb_is_black(x))) {
    struct rb_node* w = is_left ? xp -> right : xp -> left;

    if (w != NULL && rb_is_red(w)) {
      rb_set_color(w, RB_BLACK);
      rb_set_color(xp, RB_RED);
      if (is_left) rotate_left(tree, xp);
      else rotate_right(tree, xp);
      w = is_left ? xp -> right : xp -> left;
    }

    struct rb_node* wl = w != NULL ? w -> left : NULL;
    struct rb_node* wr = w != NULL ? w -> right : NULL;
    if ((wl == NULL || rb_is_black(wl)) && (wr == NULL || rb_is_black(wr))) {
      if (w != NULL) rb_set_color(w, RB_RED);
      x = xp;
      xp = rb_parent(x);
      is_left = xp && (x == x -> left);
    } else {
      if (is_left && (wr == NULL || rb_is_black(wr))) {
	rb_set_color(w, RB_RED);
	if (wl) rb_set_color(wl, RB_BLACK);
	rotate_right(tree, w);
	w = xp -> right;
      } else if (!is_left && (wl == NULL || rb_is_black(wl))) {
	rb_set_color(w, RB_RED);
	if (wr) rb_set_color(wr, RB_BLACK);
	rotate_left(tree, w);
	w = xp -> left;
      }
      wl = w -> left;
      wr = w -> right;

      rb_set_color(w, rb_color(xp));
      rb_set_color(xp, RB_BLACK);

      if (is_left && wr != NULL) {
	rb_set_color(wr, RB_BLACK);
	rotate_left(tree, xp);
      } else if (!is_left && wl != NULL) {
	rb_set_color(wl, RB_BLACK);
	rotate_right(tree, xp);
      }
      x = tree -> root;
    }
  }
  if (x != NULL) rb_set_color(x, RB_BLACK);
}

void rb_erase(struct rbtree* tree, struct rb_node* node) {
  if (node == NULL) return;
  
  if (node == tree -> most_left) tree -> most_left = rb_next(node);
  
  struct rb_node *y, *x, *xp;
  
  // Node has two children. Do the standard BST removal method so that we only have
  // to worry about deleting nodes that have at most one child (e.g one leaf node).
  if (node -> left && node -> right) {
  	// Find max element in left subtree and swap it
    struct rb_node* max;
    for (max = node -> left; max -> right != NULL; max = max -> right);
    y = max;
  } else y = node;
  
  if (y -> left != NULL) x = y -> left;
  else x = y -> right;
  
  if (x != NULL) {
    rb_set_parent(x, rb_parent(y));
    xp = rb_parent(x);
  } else xp = rb_parent(y); 
  
  int is_left = 0;
  if (rb_parent(y) == NULL) {
    tree->root = x;
    xp = NULL;
  } else {
    struct rb_node *yp = rb_parent(y);
    if (y == yp->left) {
      yp->left = x;
      is_left = 1;
    } else {
      yp->right = x;
      is_left = 0;
    }
  }
  
  int y_color = rb_color(y);
  
  // Swap in the node
  if (y != node) {
    rb_swap(tree, node, y);
    if (xp == node) xp = y;
  }
  
  if (y_color == RB_BLACK) {
    erase_rebalance(tree, x, xp, is_left);
  }
  
  node->left = NULL;
  node->right = NULL;
  rb_set_parent(node, NULL);	
}
