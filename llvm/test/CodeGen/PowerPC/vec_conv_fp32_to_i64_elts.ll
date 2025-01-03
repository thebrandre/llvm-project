; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P9
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-BE

define <2 x i64> @test2elt(i64 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtfprd f0, r3
; CHECK-P9-NEXT:    xxswapd v2, vs0
; CHECK-P9-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds v2, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtfprd f0, r3
; CHECK-BE-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds v2, vs0
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <2 x float>
  %1 = fptoui <2 x float> %0 to <2 x i64>
  ret <2 x i64> %1
}

define void @test4elt(ptr noalias nocapture sret(<4 x i64>) %agg.result, <4 x float> %a) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P8-NEXT:    xxmrghw vs1, v2, v2
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs0
; CHECK-P8-NEXT:    xvcvspdp vs0, vs1
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs0
; CHECK-P8-NEXT:    xxswapd vs1, v2
; CHECK-P8-NEXT:    stxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    xxswapd vs0, v3
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P9-NEXT:    xxmrghw vs1, v2, v2
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvspdp vs1, vs1
; CHECK-P9-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v2
; CHECK-BE-NEXT:    xxmrglw vs1, v2, v2
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs1, vs1
; CHECK-BE-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptoui <4 x float> %a to <4 x i64>
  store <4 x i64> %0, ptr %agg.result, align 32
  ret void
}

define void @test8elt(ptr noalias nocapture sret(<8 x i64>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    xxmrglw vs1, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs1, vs1
; CHECK-P8-NEXT:    xxswapd v3, vs0
; CHECK-P8-NEXT:    xxmrghw vs0, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs1
; CHECK-P8-NEXT:    xxmrglw vs2, v3, v3
; CHECK-P8-NEXT:    xxmrghw vs3, v3, v3
; CHECK-P8-NEXT:    xvcvspdp vs2, vs2
; CHECK-P8-NEXT:    xvcvspdp vs3, vs3
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v4, vs2
; CHECK-P8-NEXT:    xxswapd vs1, v2
; CHECK-P8-NEXT:    xxswapd vs0, v3
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs3
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    xxswapd vs3, v4
; CHECK-P8-NEXT:    stxvd2x vs3, 0, r3
; CHECK-P8-NEXT:    xxswapd vs2, v3
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r5
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 16(r4)
; CHECK-P9-NEXT:    lxv vs1, 0(r4)
; CHECK-P9-NEXT:    xxmrglw vs2, vs1, vs1
; CHECK-P9-NEXT:    xxmrghw vs1, vs1, vs1
; CHECK-P9-NEXT:    xxmrglw vs3, vs0, vs0
; CHECK-P9-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P9-NEXT:    xvcvspdp vs2, vs2
; CHECK-P9-NEXT:    xvcvspdp vs1, vs1
; CHECK-P9-NEXT:    xvcvspdp vs3, vs3
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-P9-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-P9-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-P9-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 48(r3)
; CHECK-P9-NEXT:    stxv vs3, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs2, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 16(r4)
; CHECK-BE-NEXT:    lxv vs1, 0(r4)
; CHECK-BE-NEXT:    xxmrghw vs2, vs1, vs1
; CHECK-BE-NEXT:    xxmrglw vs1, vs1, vs1
; CHECK-BE-NEXT:    xxmrghw vs3, vs0, vs0
; CHECK-BE-NEXT:    xxmrglw vs0, vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs2, vs2
; CHECK-BE-NEXT:    xvcvspdp vs1, vs1
; CHECK-BE-NEXT:    xvcvspdp vs3, vs3
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-BE-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-BE-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-BE-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 48(r3)
; CHECK-BE-NEXT:    stxv vs3, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x float>, ptr %0, align 32
  %1 = fptoui <8 x float> %a to <8 x i64>
  store <8 x i64> %1, ptr %agg.result, align 64
  ret void
}

define void @test16elt(ptr noalias nocapture sret(<16 x i64>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 48
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    li r4, 112
; CHECK-P8-NEXT:    xxswapd v4, vs3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xxmrglw vs6, v4, v4
; CHECK-P8-NEXT:    xxmrghw vs7, v4, v4
; CHECK-P8-NEXT:    xvcvspdp vs6, vs6
; CHECK-P8-NEXT:    xvcvspdp vs7, vs7
; CHECK-P8-NEXT:    xvcvdpuxds v1, vs7
; CHECK-P8-NEXT:    xxmrghw vs0, v2, v2
; CHECK-P8-NEXT:    xxmrglw vs1, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs1, vs1
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xxswapd v2, vs2
; CHECK-P8-NEXT:    xxmrghw vs3, v3, v3
; CHECK-P8-NEXT:    xxmrglw vs2, v3, v3
; CHECK-P8-NEXT:    xvcvspdp vs3, vs3
; CHECK-P8-NEXT:    xvcvspdp vs2, vs2
; CHECK-P8-NEXT:    xvcvdpuxds v4, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v0, vs1
; CHECK-P8-NEXT:    xvcvdpuxds v5, vs3
; CHECK-P8-NEXT:    xxmrglw vs4, v2, v2
; CHECK-P8-NEXT:    xxmrghw vs5, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs4, vs4
; CHECK-P8-NEXT:    xvcvspdp vs5, vs5
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs4
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs5
; CHECK-P8-NEXT:    xxswapd vs4, v1
; CHECK-P8-NEXT:    stxvd2x vs4, r3, r7
; CHECK-P8-NEXT:    xxswapd vs0, v4
; CHECK-P8-NEXT:    xvcvdpuxds v4, vs2
; CHECK-P8-NEXT:    xxswapd vs1, v0
; CHECK-P8-NEXT:    xvcvdpuxds v0, vs6
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 96
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    li r4, 80
; CHECK-P8-NEXT:    xxswapd vs0, v5
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 64
; CHECK-P8-NEXT:    xxswapd vs3, v2
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r6
; CHECK-P8-NEXT:    xxswapd vs1, v3
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r5
; CHECK-P8-NEXT:    xxswapd vs2, v4
; CHECK-P8-NEXT:    xxswapd vs5, v0
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 48(r4)
; CHECK-P9-NEXT:    lxv vs1, 0(r4)
; CHECK-P9-NEXT:    lxv vs3, 16(r4)
; CHECK-P9-NEXT:    lxv vs5, 32(r4)
; CHECK-P9-NEXT:    xxmrglw vs2, vs1, vs1
; CHECK-P9-NEXT:    xxmrghw vs1, vs1, vs1
; CHECK-P9-NEXT:    xxmrglw vs4, vs3, vs3
; CHECK-P9-NEXT:    xxmrghw vs3, vs3, vs3
; CHECK-P9-NEXT:    xxmrglw vs6, vs5, vs5
; CHECK-P9-NEXT:    xxmrghw vs5, vs5, vs5
; CHECK-P9-NEXT:    xxmrglw vs7, vs0, vs0
; CHECK-P9-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P9-NEXT:    xvcvspdp vs2, vs2
; CHECK-P9-NEXT:    xvcvspdp vs1, vs1
; CHECK-P9-NEXT:    xvcvspdp vs4, vs4
; CHECK-P9-NEXT:    xvcvspdp vs3, vs3
; CHECK-P9-NEXT:    xvcvspdp vs6, vs6
; CHECK-P9-NEXT:    xvcvspdp vs5, vs5
; CHECK-P9-NEXT:    xvcvspdp vs7, vs7
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-P9-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-P9-NEXT:    xvcvdpuxds vs4, vs4
; CHECK-P9-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-P9-NEXT:    xvcvdpuxds vs6, vs6
; CHECK-P9-NEXT:    xvcvdpuxds vs5, vs5
; CHECK-P9-NEXT:    xvcvdpuxds vs7, vs7
; CHECK-P9-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 112(r3)
; CHECK-P9-NEXT:    stxv vs7, 96(r3)
; CHECK-P9-NEXT:    stxv vs5, 80(r3)
; CHECK-P9-NEXT:    stxv vs6, 64(r3)
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    stxv vs4, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs2, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 0(r4)
; CHECK-BE-NEXT:    lxv vs3, 16(r4)
; CHECK-BE-NEXT:    lxv vs5, 32(r4)
; CHECK-BE-NEXT:    xxmrghw vs2, vs1, vs1
; CHECK-BE-NEXT:    xxmrglw vs1, vs1, vs1
; CHECK-BE-NEXT:    xxmrghw vs4, vs3, vs3
; CHECK-BE-NEXT:    xxmrglw vs3, vs3, vs3
; CHECK-BE-NEXT:    xxmrghw vs6, vs5, vs5
; CHECK-BE-NEXT:    xxmrglw vs5, vs5, vs5
; CHECK-BE-NEXT:    xxmrghw vs7, vs0, vs0
; CHECK-BE-NEXT:    xxmrglw vs0, vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs2, vs2
; CHECK-BE-NEXT:    xvcvspdp vs1, vs1
; CHECK-BE-NEXT:    xvcvspdp vs4, vs4
; CHECK-BE-NEXT:    xvcvspdp vs3, vs3
; CHECK-BE-NEXT:    xvcvspdp vs6, vs6
; CHECK-BE-NEXT:    xvcvspdp vs5, vs5
; CHECK-BE-NEXT:    xvcvspdp vs7, vs7
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-BE-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-BE-NEXT:    xvcvdpuxds vs4, vs4
; CHECK-BE-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-BE-NEXT:    xvcvdpuxds vs6, vs6
; CHECK-BE-NEXT:    xvcvdpuxds vs5, vs5
; CHECK-BE-NEXT:    xvcvdpuxds vs7, vs7
; CHECK-BE-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 112(r3)
; CHECK-BE-NEXT:    stxv vs7, 96(r3)
; CHECK-BE-NEXT:    stxv vs5, 80(r3)
; CHECK-BE-NEXT:    stxv vs6, 64(r3)
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    stxv vs4, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x float>, ptr %0, align 64
  %1 = fptoui <16 x float> %a to <16 x i64>
  store <16 x i64> %1, ptr %agg.result, align 128
  ret void
}

define <2 x i64> @test2elt_signed(i64 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtfprd f0, r3
; CHECK-P9-NEXT:    xxswapd v2, vs0
; CHECK-P9-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds v2, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtfprd f0, r3
; CHECK-BE-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds v2, vs0
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <2 x float>
  %1 = fptoui <2 x float> %0 to <2 x i64>
  ret <2 x i64> %1
}

define void @test4elt_signed(ptr noalias nocapture sret(<4 x i64>) %agg.result, <4 x float> %a) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P8-NEXT:    xxmrghw vs1, v2, v2
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs0
; CHECK-P8-NEXT:    xvcvspdp vs0, vs1
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs0
; CHECK-P8-NEXT:    xxswapd vs1, v2
; CHECK-P8-NEXT:    stxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    xxswapd vs0, v3
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xxmrglw vs0, v2, v2
; CHECK-P9-NEXT:    xxmrghw vs1, v2, v2
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvspdp vs1, vs1
; CHECK-P9-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxmrghw vs0, v2, v2
; CHECK-BE-NEXT:    xxmrglw vs1, v2, v2
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs1, vs1
; CHECK-BE-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptoui <4 x float> %a to <4 x i64>
  store <4 x i64> %0, ptr %agg.result, align 32
  ret void
}

define void @test8elt_signed(ptr noalias nocapture sret(<8 x i64>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    xxmrglw vs1, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs1, vs1
; CHECK-P8-NEXT:    xxswapd v3, vs0
; CHECK-P8-NEXT:    xxmrghw vs0, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs1
; CHECK-P8-NEXT:    xxmrglw vs2, v3, v3
; CHECK-P8-NEXT:    xxmrghw vs3, v3, v3
; CHECK-P8-NEXT:    xvcvspdp vs2, vs2
; CHECK-P8-NEXT:    xvcvspdp vs3, vs3
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v4, vs2
; CHECK-P8-NEXT:    xxswapd vs1, v2
; CHECK-P8-NEXT:    xxswapd vs0, v3
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs3
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    xxswapd vs3, v4
; CHECK-P8-NEXT:    stxvd2x vs3, 0, r3
; CHECK-P8-NEXT:    xxswapd vs2, v3
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r5
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 16(r4)
; CHECK-P9-NEXT:    lxv vs1, 0(r4)
; CHECK-P9-NEXT:    xxmrglw vs2, vs1, vs1
; CHECK-P9-NEXT:    xxmrghw vs1, vs1, vs1
; CHECK-P9-NEXT:    xxmrglw vs3, vs0, vs0
; CHECK-P9-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P9-NEXT:    xvcvspdp vs2, vs2
; CHECK-P9-NEXT:    xvcvspdp vs1, vs1
; CHECK-P9-NEXT:    xvcvspdp vs3, vs3
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-P9-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-P9-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-P9-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 48(r3)
; CHECK-P9-NEXT:    stxv vs3, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs2, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 16(r4)
; CHECK-BE-NEXT:    lxv vs1, 0(r4)
; CHECK-BE-NEXT:    xxmrghw vs2, vs1, vs1
; CHECK-BE-NEXT:    xxmrglw vs1, vs1, vs1
; CHECK-BE-NEXT:    xxmrghw vs3, vs0, vs0
; CHECK-BE-NEXT:    xxmrglw vs0, vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs2, vs2
; CHECK-BE-NEXT:    xvcvspdp vs1, vs1
; CHECK-BE-NEXT:    xvcvspdp vs3, vs3
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-BE-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-BE-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-BE-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 48(r3)
; CHECK-BE-NEXT:    stxv vs3, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x float>, ptr %0, align 32
  %1 = fptoui <8 x float> %a to <8 x i64>
  store <8 x i64> %1, ptr %agg.result, align 64
  ret void
}

define void @test16elt_signed(ptr noalias nocapture sret(<16 x i64>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 48
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    li r4, 112
; CHECK-P8-NEXT:    xxswapd v4, vs3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xxswapd v3, vs1
; CHECK-P8-NEXT:    xxmrglw vs6, v4, v4
; CHECK-P8-NEXT:    xxmrghw vs7, v4, v4
; CHECK-P8-NEXT:    xvcvspdp vs6, vs6
; CHECK-P8-NEXT:    xvcvspdp vs7, vs7
; CHECK-P8-NEXT:    xvcvdpuxds v1, vs7
; CHECK-P8-NEXT:    xxmrghw vs0, v2, v2
; CHECK-P8-NEXT:    xxmrglw vs1, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs1, vs1
; CHECK-P8-NEXT:    xvcvspdp vs0, vs0
; CHECK-P8-NEXT:    xxswapd v2, vs2
; CHECK-P8-NEXT:    xxmrghw vs3, v3, v3
; CHECK-P8-NEXT:    xxmrglw vs2, v3, v3
; CHECK-P8-NEXT:    xvcvspdp vs3, vs3
; CHECK-P8-NEXT:    xvcvspdp vs2, vs2
; CHECK-P8-NEXT:    xvcvdpuxds v4, vs0
; CHECK-P8-NEXT:    xvcvdpuxds v0, vs1
; CHECK-P8-NEXT:    xvcvdpuxds v5, vs3
; CHECK-P8-NEXT:    xxmrglw vs4, v2, v2
; CHECK-P8-NEXT:    xxmrghw vs5, v2, v2
; CHECK-P8-NEXT:    xvcvspdp vs4, vs4
; CHECK-P8-NEXT:    xvcvspdp vs5, vs5
; CHECK-P8-NEXT:    xvcvdpuxds v2, vs4
; CHECK-P8-NEXT:    xvcvdpuxds v3, vs5
; CHECK-P8-NEXT:    xxswapd vs4, v1
; CHECK-P8-NEXT:    stxvd2x vs4, r3, r7
; CHECK-P8-NEXT:    xxswapd vs0, v4
; CHECK-P8-NEXT:    xvcvdpuxds v4, vs2
; CHECK-P8-NEXT:    xxswapd vs1, v0
; CHECK-P8-NEXT:    xvcvdpuxds v0, vs6
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 96
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r4
; CHECK-P8-NEXT:    li r4, 80
; CHECK-P8-NEXT:    xxswapd vs0, v5
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 64
; CHECK-P8-NEXT:    xxswapd vs3, v2
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r6
; CHECK-P8-NEXT:    xxswapd vs1, v3
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r5
; CHECK-P8-NEXT:    xxswapd vs2, v4
; CHECK-P8-NEXT:    xxswapd vs5, v0
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    stxvd2x vs5, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 48(r4)
; CHECK-P9-NEXT:    lxv vs1, 0(r4)
; CHECK-P9-NEXT:    lxv vs3, 16(r4)
; CHECK-P9-NEXT:    lxv vs5, 32(r4)
; CHECK-P9-NEXT:    xxmrglw vs2, vs1, vs1
; CHECK-P9-NEXT:    xxmrghw vs1, vs1, vs1
; CHECK-P9-NEXT:    xxmrglw vs4, vs3, vs3
; CHECK-P9-NEXT:    xxmrghw vs3, vs3, vs3
; CHECK-P9-NEXT:    xxmrglw vs6, vs5, vs5
; CHECK-P9-NEXT:    xxmrghw vs5, vs5, vs5
; CHECK-P9-NEXT:    xxmrglw vs7, vs0, vs0
; CHECK-P9-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P9-NEXT:    xvcvspdp vs2, vs2
; CHECK-P9-NEXT:    xvcvspdp vs1, vs1
; CHECK-P9-NEXT:    xvcvspdp vs4, vs4
; CHECK-P9-NEXT:    xvcvspdp vs3, vs3
; CHECK-P9-NEXT:    xvcvspdp vs6, vs6
; CHECK-P9-NEXT:    xvcvspdp vs5, vs5
; CHECK-P9-NEXT:    xvcvspdp vs7, vs7
; CHECK-P9-NEXT:    xvcvspdp vs0, vs0
; CHECK-P9-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-P9-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-P9-NEXT:    xvcvdpuxds vs4, vs4
; CHECK-P9-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-P9-NEXT:    xvcvdpuxds vs6, vs6
; CHECK-P9-NEXT:    xvcvdpuxds vs5, vs5
; CHECK-P9-NEXT:    xvcvdpuxds vs7, vs7
; CHECK-P9-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 112(r3)
; CHECK-P9-NEXT:    stxv vs7, 96(r3)
; CHECK-P9-NEXT:    stxv vs5, 80(r3)
; CHECK-P9-NEXT:    stxv vs6, 64(r3)
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    stxv vs4, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs2, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 0(r4)
; CHECK-BE-NEXT:    lxv vs3, 16(r4)
; CHECK-BE-NEXT:    lxv vs5, 32(r4)
; CHECK-BE-NEXT:    xxmrghw vs2, vs1, vs1
; CHECK-BE-NEXT:    xxmrglw vs1, vs1, vs1
; CHECK-BE-NEXT:    xxmrghw vs4, vs3, vs3
; CHECK-BE-NEXT:    xxmrglw vs3, vs3, vs3
; CHECK-BE-NEXT:    xxmrghw vs6, vs5, vs5
; CHECK-BE-NEXT:    xxmrglw vs5, vs5, vs5
; CHECK-BE-NEXT:    xxmrghw vs7, vs0, vs0
; CHECK-BE-NEXT:    xxmrglw vs0, vs0, vs0
; CHECK-BE-NEXT:    xvcvspdp vs2, vs2
; CHECK-BE-NEXT:    xvcvspdp vs1, vs1
; CHECK-BE-NEXT:    xvcvspdp vs4, vs4
; CHECK-BE-NEXT:    xvcvspdp vs3, vs3
; CHECK-BE-NEXT:    xvcvspdp vs6, vs6
; CHECK-BE-NEXT:    xvcvspdp vs5, vs5
; CHECK-BE-NEXT:    xvcvspdp vs7, vs7
; CHECK-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-BE-NEXT:    xvcvdpuxds vs2, vs2
; CHECK-BE-NEXT:    xvcvdpuxds vs1, vs1
; CHECK-BE-NEXT:    xvcvdpuxds vs4, vs4
; CHECK-BE-NEXT:    xvcvdpuxds vs3, vs3
; CHECK-BE-NEXT:    xvcvdpuxds vs6, vs6
; CHECK-BE-NEXT:    xvcvdpuxds vs5, vs5
; CHECK-BE-NEXT:    xvcvdpuxds vs7, vs7
; CHECK-BE-NEXT:    xvcvdpuxds vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 112(r3)
; CHECK-BE-NEXT:    stxv vs7, 96(r3)
; CHECK-BE-NEXT:    stxv vs5, 80(r3)
; CHECK-BE-NEXT:    stxv vs6, 64(r3)
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    stxv vs4, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs2, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x float>, ptr %0, align 64
  %1 = fptoui <16 x float> %a to <16 x i64>
  store <16 x i64> %1, ptr %agg.result, align 128
  ret void
}
