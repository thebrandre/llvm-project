// RUN: %clang_cc1 -std=c++11 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++14 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++20 -fsyntax-only %s -verify

template <typename T>
struct S {
  enum E : T;

  static int f1();
  static int f2();
};

template <>
enum S<char>::E : char { A, B, C }; // expected-note {{enum 'S<char>::E' was explicitly specialized here}}

template <typename T>
enum S<T>::E : T { X, Y, Z };

const int X = 0;

template <typename T>
int S<T>::f1() { return static_cast<int>(X); }

template <typename T>
int S<T>::f2() { return static_cast<int>(Y); } // expected-error {{enumerator 'Y' does not exist in instantiation of 'S<char>'}}

auto x = S<char>::f1();
auto y = S<char>::f2(); // expected-note {{in instantiation of member function 'S<char>::f2' requested here}}