// RUN: %clang_cc1 -std=c++11 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++14 -fsyntax-only %s -verify
// RUN: %clang_cc1 -std=c++20 -fsyntax-only %s -verify


// see [temp.expl.spec] example 4
namespace ScopedEnumerations {
template <class T>
struct S1 {
  enum class E : T;
};

const int X=42;
const int Y=42;
const int Z=42;

S1<char> a1;
S1<int> a2;

template <>
enum class S1<int>::E : int {
  X = 0x123
};

template <class T>
enum class S1<T>::E : T {
  Y
};

template <>
enum class S1<char>::E : char {
  Z = 'a'
};

static_assert(static_cast<char>(S1<char>::E::Z) == 'a', "");
static_assert(static_cast<int>(S1<int>::E::X) == 0x123, "");
static_assert(static_cast<unsigned>(S1<unsigned>::E::Y) == 0u, "");


template <typename T>
struct S2 {
  static constexpr T f(int) { return 0; };
  enum class E : T;
  static constexpr T f(char) { return 1; };
  enum class E : T { X = f(T{}) };
};

static_assert(static_cast<int>(S2<char>::E::X) == 1);

template <typename T>
struct S3 {
  enum class E : T;
  enum class E : T { X = 0x7FFFFF00 }; // expected-warning {{implicit conversion from 'int' to 'char' changes value}} expected-error {{cannot be narrowed to type 'char'}}
};
template struct S3<char>; // expected-note {{in instantiation of template class}}

}


namespace UnscopedEnumerations {

template <class T>
struct S1 {
  enum E : T;
};

S1<char> a1; // expected-note {{implicit instantiation first required here}}
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
enum S1<char>::E : char {
  AZ = 'a' // expected-error {{error: explicit specialization of 'S' after instantiation}}
};

static_assert(static_cast<char>(S1<char>::AZ) == 'a', "");
static_assert(static_cast<int>(S1<int>::AX) == 0x123, "");
static_assert(static_cast<unsigned>(S1<unsigned>::AY) == 0u, "");

template <typename T>
struct S2 {
  static constexpr T f(int) { return 0; };
  enum E : T;
  static constexpr T f(char) { return 1; };
  enum E : T { X = f(T{}) };
};

static_assert(static_cast<int>(S2<char>::E::X) == 1, "");

template <typename T>
struct S3 {
  enum E : T;
  enum E : T { X = 0x7FFFFF00 }; // expected-warning {{implicit conversion from 'int' to 'char' changes value}} expected-error {{cannot be narrowed to type 'char'}}
};
template struct S3<char>; // expected-note {{in instantiation of template class}}

}