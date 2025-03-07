//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <set>

// class multiset

// template <class InputIterator>
//     multiset(InputIterator first, InputIterator last, const value_compare& comp);

#include <set>
#include <cassert>

#include "test_macros.h"
#include "test_iterators.h"
#include "../../../test_compare.h"

int main(int, char**) {
  typedef int V;
  V ar[] = {1, 1, 1, 2, 2, 2, 3, 3, 3};
  typedef test_less<V> C;
  std::multiset<V, C> m(
      cpp17_input_iterator<const V*>(ar), cpp17_input_iterator<const V*>(ar + sizeof(ar) / sizeof(ar[0])), C(5));
  assert(m.value_comp() == C(5));
  assert(m.size() == 9);
  assert(std::distance(m.begin(), m.end()) == 9);
  assert(*std::next(m.begin(), 0) == 1);
  assert(*std::next(m.begin(), 1) == 1);
  assert(*std::next(m.begin(), 2) == 1);
  assert(*std::next(m.begin(), 3) == 2);
  assert(*std::next(m.begin(), 4) == 2);
  assert(*std::next(m.begin(), 5) == 2);
  assert(*std::next(m.begin(), 6) == 3);
  assert(*std::next(m.begin(), 7) == 3);
  assert(*std::next(m.begin(), 8) == 3);

  return 0;
}
