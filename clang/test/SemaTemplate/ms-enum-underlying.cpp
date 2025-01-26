// RUN: %clang_cc1 -triple x86_64-windows-msvc -fms-extensions -verify -std=c++11
// expected-no-diagnostics

template <typename T>
struct S {
  enum E { X, Y };
};

enum E { X, Y };

namespace test {
template <typename T1, typename T2>
struct IsSame {
  static constexpr bool check() { return false; }
};

template <typename T>
struct IsSame<T, T> {
  static constexpr bool check() { return true; }
};
}  // namespace test

#ifdef _MSC_VER
static_assert(test::IsSame<__underlying_type(E), int>::check(), "");
static_assert(test::IsSame<__underlying_type(S<char>::E), int>::check(), "");
#else
static_assert(test::IsSame<__underlying_type(E), unsigned>::check(), "");
static_assert(test::IsSame<__underlying_type(S<char>::E), unsigned>::check(), "");
#endif
