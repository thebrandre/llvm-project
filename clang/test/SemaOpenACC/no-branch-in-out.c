// RUN: %clang_cc1 %s -verify -fopenacc

void BreakContinue() {

#pragma acc parallel
  for(int i =0; i < 5; ++i) {
    switch(i) {
      case 0:
      break; // leaves switch, not 'for'.
      default:
      i +=2;
      break;
    }
    if (i == 2)
      continue;

    break;  // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

#pragma acc parallel loop
  for(int i =0; i < 5; ++i) {
    switch(i) {
      case 0:
      break; // leaves switch, not 'for'.
      default:
      i +=2;
      break;
    }
    if (i == 2)
      continue;

    break;  // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

  int j;
  switch(j) {
    case 0:
#pragma acc parallel
    {
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
    }
    case 1:
#pragma acc parallel
    {
    }
    break;
  }

#pragma acc parallel
  for(int i = 0; i < 5; ++i) {
    if (i > 1)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

#pragma acc parallel loop
  for(int i = 0; i < 5; ++i) {
    if (i > 1)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

#pragma acc serial
  for(int i = 0; i < 5; ++i) {
    if (i > 1)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

#pragma acc serial loop
  for(int i = 0; i < 5; ++i) {
    if (i > 1)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

#pragma acc kernels
  for(int i = 0; i < 5; ++i) {
    if (i > 1)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

#pragma acc kernels loop
  for(int i = 0; i < 5; ++i) {
    if (i > 1)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }

#pragma acc parallel
  switch(j) {
    case 1:
      break;
  }

#pragma acc parallel
  {
    for(int i = 1; i < 100; i++) {
      if (i > 4)
        break;
    }
  }

  for (int i =0; i < 5; ++i) {
#pragma acc parallel
    {
      continue; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
    }
  }

#pragma acc parallel
  for (int i =0; i < 5; ++i) {
    continue;
  }

#pragma acc parallel loop
  for (int i =0; i < 5; ++i) {
    continue;
  }

#pragma acc parallel
  for (int i =0; i < 5; ++i) {
    {
      continue;
    }
  }

#pragma acc parallel loop
  for (int i =0; i < 5; ++i) {
    {
      continue;
    }
  }

  for (int i =0; i < 5; ++i) {
#pragma acc parallel
    {
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
    }
  }

#pragma acc parallel
  while (j) {
    --j;
    if (j > 4)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  }
#pragma acc parallel
  do {
    --j;
    if (j > 4)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}
  } while (j );
}

void Return() {
#pragma acc parallel
  {
    return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
    return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
  }

#pragma acc serial
  {
    return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
  }

#pragma acc serial loop
  for (unsigned i = 0; i < 5; ++i) {
    return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
  }

#pragma acc kernels
  {
    return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
  }

#pragma acc kernels loop
  for (unsigned i = 0; i < 5; ++i) {
    return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
  }

#pragma acc parallel
  {
    {
      return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
    }
  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
    {
      return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
    }
  }

#pragma acc parallel
  {
    for (int i = 0; i < 5; ++i) {
      return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
    }
  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
    for (int i = 0; i < 5; ++i) {
      return;// expected-error{{invalid return out of OpenACC Compute/Combined Construct}}
    }
  }
}

void Goto() {
  int j;
#pragma acc parallel // expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  while(j) {
    if (j <3)
      goto LABEL; // expected-error{{cannot jump from this goto statement to its label}}
  }

LABEL:
  {}

  goto LABEL_IN; // expected-error{{cannot jump from this goto statement to its label}}
#pragma acc parallel // expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for(int i = 0; i < 5; ++i) {
LABEL_IN:
    {}
  }

  int i;
  goto LABEL_IN2; // expected-error{{cannot jump from this goto statement to its label}}
#pragma acc parallel loop // expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for(i = 0; i < 5; ++i) {
LABEL_IN2:
    {}
  }

#pragma acc parallel
  for(int i = 0; i < 5; ++i) {
LABEL_NOT_CALLED:
    {}
  }

#pragma acc parallel loop
  for(int i = 0; i < 5; ++i) {
LABEL_NOT_CALLED2:
    {}
  }

#pragma acc parallel
  {
    goto ANOTHER_LOOP; // expected-error{{cannot jump from this goto statement to its label}}

  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
    goto ANOTHER_LOOP2; // expected-error{{cannot jump from this goto statement to its label}}

  }

#pragma acc parallel// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  {
ANOTHER_LOOP:
    {}
  }

#pragma acc parallel loop// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
ANOTHER_LOOP2:
    {}
  }

#pragma acc parallel
  {
  while (j) {
    --j;
    if (j < 3)
      goto LABEL2;

    if (j > 4)
      break;
  }
LABEL2:
  {}
  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
  while (j) {
    --j;
    if (j < 3)
      goto LABEL2_2;

    if (j > 4)
      break;
  }
LABEL2_2:
  {}
  }


#pragma acc parallel
  do {
    if (j < 3)
      goto LABEL3;

    if (j > 4)
      break; // expected-error{{invalid branch out of OpenACC Compute/Combined Construct}}

LABEL3:
  {}
  } while (j);


LABEL4:
  {}

#pragma acc parallel// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  {
    goto LABEL4;// expected-error{{cannot jump from this goto statement to its label}}
  }

#pragma acc parallel loop// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
    goto LABEL4;// expected-error{{cannot jump from this goto statement to its label}}
  }


#pragma acc parallel// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  {
LABEL5:
    {}
  }

#pragma acc parallel loop// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
LABEL5_2:
    {}
  }

  {
    goto LABEL5;// expected-error{{cannot jump from this goto statement to its label}}
    goto LABEL5_2;// expected-error{{cannot jump from this goto statement to its label}}
  }

#pragma acc parallel
  {
LABEL6:
    {}
    goto LABEL6;

  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
LABEL6_2:
    {}
    goto LABEL6_2;

  }

#pragma acc parallel
  goto LABEL7; // expected-error{{cannot jump from this goto statement to its label}}
#pragma acc parallel// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  {
LABEL7:{}
  }

#pragma acc parallel
  LABEL8:{}
#pragma acc parallel// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  {
    goto LABEL8;// expected-error{{cannot jump from this goto statement to its label}}
  }

#pragma acc parallel// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  {
LABEL9:{}
  }

  ({goto LABEL9;});// expected-error{{cannot jump from this goto statement to its label}}

#pragma acc parallel loop// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
LABEL9_2:{}
  }

  ({goto LABEL9_2;});// expected-error{{cannot jump from this goto statement to its label}}


#pragma acc parallel// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
  ({goto LABEL10;});// expected-error{{cannot jump from this goto statement to its label}}
  }

LABEL10:{}

#pragma acc parallel loop// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
  ({goto LABEL10_2;});// expected-error{{cannot jump from this goto statement to its label}}
  }

LABEL10_2:{}

  ({goto LABEL11;});// expected-error{{cannot jump from this goto statement to its label}}
#pragma acc parallel// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  {
LABEL11:{}
  }

  ({goto LABEL11_2;});// expected-error{{cannot jump from this goto statement to its label}}
#pragma acc parallel loop// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
LABEL11_2:{}
  }

LABEL12:{}
#pragma acc parallel// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  {
  ({goto LABEL12;});// expected-error{{cannot jump from this goto statement to its label}}
  }

LABEL12_2:{}
#pragma acc parallel loop// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
  ({goto LABEL12_2;});// expected-error{{cannot jump from this goto statement to its label}}
  }

#pragma acc parallel
  {
  ({goto LABEL13;});
LABEL13:{}
  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
  ({goto LABEL13_2;});
LABEL13_2:{}
  }

#pragma acc parallel
  {
  LABEL14:{}
  ({goto LABEL14;});
  }

#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
  LABEL14_2:{}
  ({goto LABEL14_2;});
  }



  ({goto LABEL15;});// expected-error{{cannot jump from this goto statement to its label}}
#pragma acc serial// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  {
LABEL15:{}
  }
  ({goto LABEL15_2;});// expected-error{{cannot jump from this goto statement to its label}}
#pragma acc serial loop// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
LABEL15_2:{}
  }

LABEL16:{}
#pragma acc serial// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  {
  ({goto LABEL16;});// expected-error{{cannot jump from this goto statement to its label}}
  }

LABEL16_2:{}
#pragma acc serial loop// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
  ({goto LABEL16_2;});// expected-error{{cannot jump from this goto statement to its label}}
  }

  ({goto LABEL17;});// expected-error{{cannot jump from this goto statement to its label}}
#pragma acc kernels// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  {
LABEL17:{}
  }

  ({goto LABEL17_2;});// expected-error{{cannot jump from this goto statement to its label}}
#pragma acc kernels loop// expected-note{{invalid branch into OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
LABEL17_2:{}
  }

LABEL18:{}
#pragma acc kernels// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  {
  ({goto LABEL18;});// expected-error{{cannot jump from this goto statement to its label}}
  }

LABEL18_2:{}
#pragma acc kernels loop// expected-note{{invalid branch out of OpenACC Compute/Combined Construct}}
  for (unsigned i = 0; i < 5; ++i) {
  ({goto LABEL18_2;});// expected-error{{cannot jump from this goto statement to its label}}
  }
}

void IndirectGoto1() {
  void* ptr;
#pragma acc parallel
  {
LABEL1:{}
    ptr = &&LABEL1;
    goto *ptr;

  }
}

void IndirectGoto1_Loop() {
  void *ptr;
#pragma acc parallel loop
  for (unsigned i = 0; i < 5; ++i) {
LABEL1:{}
    ptr = &&LABEL1;

    goto *ptr;

  }
}

void IndirectGoto2() {
  void* ptr;
LABEL2:{} // #GOTOLBL2
    ptr = &&LABEL2;
#pragma acc parallel // #GOTOPAR2
  {
// expected-error@+3{{cannot jump from this indirect goto statement to one of its possible targets}}
// expected-note@#GOTOLBL2{{possible target of indirect goto statement}}
// expected-note@#GOTOPAR2{{invalid branch out of OpenACC Compute/Combined Construct}}
    goto *ptr;
  }

#pragma acc parallel loop // #GOTOPAR_LOOP2
  for (unsigned i = 0; i < 5; ++i) {
// expected-error@+3{{cannot jump from this indirect goto statement to one of its possible targets}}
// expected-note@#GOTOLBL2{{possible target of indirect goto statement}}
// expected-note@#GOTOPAR_LOOP2{{invalid branch out of OpenACC Compute/Combined Construct}}
    goto *ptr;
  }
}

void IndirectGoto3() {
  void* ptr;
#pragma acc parallel // #GOTOPAR3
  {
LABEL3:{} // #GOTOLBL3
    ptr = &&LABEL3;
  }
// expected-error@+3{{cannot jump from this indirect goto statement to one of its possible targets}}
// expected-note@#GOTOLBL3{{possible target of indirect goto statement}}
// expected-note@#GOTOPAR3{{invalid branch into OpenACC Compute/Combined Construct}}
  goto *ptr;
}

void IndirectGoto3_Loop() {
  void* ptr;
#pragma acc parallel loop// #GOTOPAR_LOOP3
  for (unsigned i = 0; i < 5; ++i) {
LABEL3:{} // #GOTOLBL3_2
    ptr = &&LABEL3;
  }
// expected-error@+3{{cannot jump from this indirect goto statement to one of its possible targets}}
// expected-note@#GOTOLBL3_2{{possible target of indirect goto statement}}
// expected-note@#GOTOPAR_LOOP3{{invalid branch into OpenACC Compute/Combined Construct}}
  goto *ptr;
}

void IndirectGoto4() {
  void* ptr;
#pragma acc parallel // #GOTOPAR4
  {
LABEL4:{}
    ptr = &&LABEL4;
// expected-error@+3{{cannot jump from this indirect goto statement to one of its possible targets}}
// expected-note@#GOTOLBL5{{possible target of indirect goto statement}}
// expected-note@#GOTOPAR4{{invalid branch out of OpenACC Compute/Combined Construct}}
    goto *ptr;
  }
LABEL5:// #GOTOLBL5

  ptr=&&LABEL5;
}

void IndirectGoto4_2() {
  void* ptr;
#pragma acc parallel loop // #GOTOPAR_LOOP4
  for (unsigned i = 0; i < 5; ++i) {
LABEL4:{}
    ptr = &&LABEL4;
// expected-error@+3{{cannot jump from this indirect goto statement to one of its possible targets}}
// expected-note@#GOTOLBL_LOOP5{{possible target of indirect goto statement}}
// expected-note@#GOTOPAR_LOOP4{{invalid branch out of OpenACC Compute/Combined Construct}}
    goto *ptr;
  }
LABEL5:// #GOTOLBL_LOOP5

  ptr=&&LABEL5;
}

void DuffsDevice() {
  int j;
  switch (j) {
#pragma acc parallel
  for(int i =0; i < 5; ++i) {
    case 0: // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc parallel
  for(int i =0; i < 5; ++i) {
    default: // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc kernels
  for(int i =0; i < 5; ++i) {
    default: // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc parallel
  for(int i =0; i < 5; ++i) {
    case 'a' ... 'z': // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc serial
  for(int i =0; i < 5; ++i) {
    case 'a' ... 'z': // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }
}

void DuffsDeviceLoop() {
  int j;
  switch (j) {
#pragma acc parallel loop
  for(int i =0; i < 5; ++i) {
    case 0: // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc parallel loop
  for(int i =0; i < 5; ++i) {
    default: // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc kernels loop
  for(int i =0; i < 5; ++i) {
    default: // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc parallel loop
  for(int i =0; i < 5; ++i) {
    case 'a' ... 'z': // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }

  switch (j) {
#pragma acc serial loop
  for(int i =0; i < 5; ++i) {
    case 'a' ... 'z': // expected-error{{invalid branch into OpenACC Compute/Combined Construct}}
      {}
  }
  }
}
