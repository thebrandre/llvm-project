// RUN: %clang_cc1 -std=c++11 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++14 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++20 -fsyntax-only %s -verify

namespace UnscopedEnumerations {

// The following test is the part of Example 4 from C++23 [temp.expl.spec] p7
// that refers to unscoped member enumerations

template<class T> struct A {
  enum E : T;
};
template<> enum A<int>::E : int { eint };
template<class T> enum A<T>::E : T { eT };
template<> enum A<char>::E : char { echar }; // expected-error {{explicit specialization of 'E' after instantiation}} // expected-note {{implicit instantiation first required here}}

// FIXME: the diagnostics are gone if there are implicit instantiations in-between

template <class T>
struct S1 {
  enum E : T;
};

// These instantiations "heal" the error
S1<char> a1;
S1<int> a2;

template <>
enum S1<int>::E : int {
  AX = 0x123
};

template <class T>
enum S1<T>::E : T {
  AY
};

template <>
enum S1<char>::E : char { // expected-error {{explicit specialization of 'E' after instantiation}} // expected-note {{implicit instantiation first required here}}
  AZ = 'a'
};

static_assert(static_cast<int>(S1<int>::AX) == 0x123, "");
static_assert(static_cast<unsigned>(S1<unsigned>::AY) == 0u, "");

}

namespace ScopedEnumerations {

// The following test is the part of Example 4 from C++23 [temp.expl.spec] p7
// that refers to scoped member enumerations

template<class T> struct A {
  enum class S : T;
};
template<> enum class A<int>::S : int { sint };
template<class T> enum class A<T>::S : T { sT };
template<> enum class A<char>::S : char { schar };

}