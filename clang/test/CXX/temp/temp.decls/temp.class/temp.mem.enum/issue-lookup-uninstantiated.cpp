// RUN: %clang_cc1 -std=c++11 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++20 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++23 -fsyntax-only %s -verify

// This is somewhat obscure behavior in C++ which was brought up in:
// CWG1485: "Out-of-class definition of member unscoped opaque enumeration"

// C++11 (N3242) [dcl.enum] p11
// "Each enum-name and each unscoped enumerator is declared in the scope that
// immediately contains the enum-specifier."

// Confirmed by "P1787R6: Declarations and where to find them"
// C++23 (N4950) [dcl.enum] p12
// "The name of each unscoped enumerator is also bound in the scope that
// immediately contains the enum-specifier."

// I don't think this is intended behavior because it causes even more
// problems if the enum is part of a template class. In this case, each
// instantiation will introduce potentially conflicting names.

struct S1 {
  enum E : int;
};

enum S1::E : int { S1_X = 1, S1_Y = 2, S1_Z = 3 };

auto x1 = S1_X;
auto y1 = S1::S1_Y;

static_assert(S1_X == S1::S1_X, "");

struct S2 {
  enum class E : int;
};

enum class S2::E : int { S2_X = 1, S2_Y = 2, S2_Z = 3 };

auto x2 = E::S2_X; // expected-error {{use of undeclared identifier 'E'}}
auto y2 = S2::E::S2_Y;

template <typename T>
struct S3 {
  enum E : T;
};

int S3_X = 42; // expected-note {{candidate found by name lookup is 'S3_X'}}

template <typename T>
enum S3<T>::E : T {
  S3_X = 11, // expected-note {{candidate found by name lookup is 'S3::S3_X'}}
  S3_Y = 12,
  S3_Z = 13
};

auto x3 = S3_X; // expected-error {{'S3_X' is ambiguous}}
auto y3 = S3<int>::S3_Y;

// FIXME: causes a crash

template <typename T>
struct S4 {
  enum E : T;
};

template <typename T>
enum S4<T>::E : T { S4_X };

auto x = S4_X;