// RUN: %clang_analyze_cc1 -fblocks -analyze -analyzer-checker=core,nullability,apiModeling  -verify %s

#include "Inputs/system-header-simulator-for-nullability.h"

NSString* getUnknownString();

NSString* _Nonnull trust_nonnull_framework_annotation() {
  NSString* out = [NSString generateString];
  if (out) {}
  return out; // no-warning
}

NSString* _Nonnull distrust_without_annotation() {
  NSString* out = [NSString generatePossiblyNullString];
  if (out) {}
  return out; // expected-warning{{}}
}

NSString* _Nonnull nonnull_please_trust_me();

NSString* _Nonnull distrust_local_nonnull_annotation() {
  NSString* out = nonnull_please_trust_me();
  if (out) {}
  return out; // expected-warning{{}}
}

NSString* _Nonnull trust_c_function() {
  NSString* out = getString();
  if (out) {};
  return out; // no-warning
}

NSString* _Nonnull distrust_unannoted_function() {
  NSString* out = getPossiblyNullString();
  if (out) {};
  return out; // expected-warning{{}}
}

NSString * _Nonnull distrustProtocol(id<MyProtocol> o) {
  NSString* out = [o getString];
  if (out) {};
  return out; // expected-warning{{}}
}
