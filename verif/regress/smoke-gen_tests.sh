# Copyright 2023 Thales DIS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Ayoub JALALI - Thales

# where are the tools
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi

# install the required tools
source verif/regress/install-cva6.sh
source verif/regress/install-riscv-dv.sh

if ! [ -n "$DV_TARGET" ]; then
  DV_TARGET=cv32a6_embedded
fi

if ! [ -n "$DV_SIMULATORS" ]; then
  DV_SIMULATORS=vcs-uvm,spike
fi

cd verif/sim/
cp ../env/corev-dv/custom/riscv_custom_instr_enum.sv ./dv/src/isa/custom/
python3 cva6.py --testlist=cva6_base_testlist.yaml --test riscv_arithmetic_basic_test_comp --iss_yaml cva6.yaml --target $DV_TARGET -cs ../env/corev-dv/target/rv32imcb/ --mabi ilp32 --isa rv32imc --isa_extension="zba,zbb,zbc,zbs" --simulator_yaml ../env/corev-dv/simulator.yaml --iss=$DV_SIMULATORS $DV_OPTS -i 1 --iss_timeout 300
python3 cva6.py --testlist=cva6_base_testlist.yaml --test riscv_load_store_test --iss_yaml cva6.yaml --target $DV_TARGET -cs ../env/corev-dv/target/rv32imcb/ --mabi ilp32 --isa rv32imc --isa_extension="zba,zbb,zbc,zbs" --simulator_yaml ../env/corev-dv/simulator.yaml --iss=$DV_SIMULATORS $DV_OPTS -i 1 --iss_timeout 300
python3 cva6.py --testlist=cva6_base_testlist.yaml --test riscv_unaligned_load_store_test --iss_yaml cva6.yaml --target $DV_TARGET -cs ../env/corev-dv/target/rv32imcb/ --mabi ilp32 --isa rv32imc --isa_extension="zba,zbb,zbc,zbs" --simulator_yaml ../env/corev-dv/simulator.yaml --iss=$DV_SIMULATORS $DV_OPTS -i 1 --iss_timeout 300
make clean_all

cd -
