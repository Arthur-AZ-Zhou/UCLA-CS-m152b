/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_781(char*, char *);
extern void execute_3558(char*, char *);
extern void execute_3559(char*, char *);
extern void execute_3560(char*, char *);
extern void execute_3547(char*, char *);
extern void execute_3548(char*, char *);
extern void execute_3549(char*, char *);
extern void execute_3550(char*, char *);
extern void execute_3551(char*, char *);
extern void execute_3552(char*, char *);
extern void execute_3553(char*, char *);
extern void execute_3554(char*, char *);
extern void execute_3555(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_994(char*, char *);
extern void execute_796(char*, char *);
extern void execute_797(char*, char *);
extern void execute_798(char*, char *);
extern void execute_786(char*, char *);
extern void execute_787(char*, char *);
extern void execute_788(char*, char *);
extern void execute_789(char*, char *);
extern void execute_790(char*, char *);
extern void execute_1431(char*, char *);
extern void execute_995(char*, char *);
extern void execute_996(char*, char *);
extern void execute_997(char*, char *);
extern void execute_998(char*, char *);
extern void execute_999(char*, char *);
extern void execute_1000(char*, char *);
extern void execute_1001(char*, char *);
extern void execute_1002(char*, char *);
extern void execute_1003(char*, char *);
extern void execute_1004(char*, char *);
extern void execute_1005(char*, char *);
extern void execute_1006(char*, char *);
extern void execute_1007(char*, char *);
extern void execute_1008(char*, char *);
extern void execute_1009(char*, char *);
extern void execute_1010(char*, char *);
extern void execute_1220(char*, char *);
extern void execute_1221(char*, char *);
extern void execute_1432(char*, char *);
extern void execute_1433(char*, char *);
extern void execute_1434(char*, char *);
extern void execute_1435(char*, char *);
extern void execute_1436(char*, char *);
extern void execute_1437(char*, char *);
extern void execute_1438(char*, char *);
extern void execute_1439(char*, char *);
extern void execute_1440(char*, char *);
extern void execute_1441(char*, char *);
extern void execute_1442(char*, char *);
extern void execute_1443(char*, char *);
extern void execute_1444(char*, char *);
extern void execute_1445(char*, char *);
extern void execute_1446(char*, char *);
extern void execute_1447(char*, char *);
extern void execute_1448(char*, char *);
extern void execute_1449(char*, char *);
extern void execute_1450(char*, char *);
extern void execute_1451(char*, char *);
extern void execute_1452(char*, char *);
extern void execute_1453(char*, char *);
extern void execute_1454(char*, char *);
extern void execute_1455(char*, char *);
extern void execute_1456(char*, char *);
extern void execute_1457(char*, char *);
extern void execute_1458(char*, char *);
extern void execute_1459(char*, char *);
extern void execute_1460(char*, char *);
extern void execute_1461(char*, char *);
extern void execute_1462(char*, char *);
extern void execute_1463(char*, char *);
extern void execute_1884(char*, char *);
extern void execute_1885(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_2113(char*, char *);
extern void execute_2114(char*, char *);
extern void execute_2115(char*, char *);
extern void execute_2116(char*, char *);
extern void execute_2118(char*, char *);
extern void execute_2119(char*, char *);
extern void execute_2120(char*, char *);
extern void execute_2121(char*, char *);
extern void execute_2570(char*, char *);
extern void execute_2571(char*, char *);
extern void execute_2632(char*, char *);
extern void execute_2693(char*, char *);
extern void execute_2754(char*, char *);
extern void execute_2815(char*, char *);
extern void execute_2876(char*, char *);
extern void execute_2937(char*, char *);
extern void execute_2998(char*, char *);
extern void execute_3059(char*, char *);
extern void execute_3120(char*, char *);
extern void execute_3181(char*, char *);
extern void execute_3242(char*, char *);
extern void execute_3303(char*, char *);
extern void execute_3364(char*, char *);
extern void execute_3425(char*, char *);
extern void execute_3486(char*, char *);
extern void execute_2572(char*, char *);
extern void execute_2573(char*, char *);
extern void execute_2574(char*, char *);
extern void execute_2575(char*, char *);
extern void execute_783(char*, char *);
extern void execute_784(char*, char *);
extern void execute_785(char*, char *);
extern void execute_3561(char*, char *);
extern void execute_3562(char*, char *);
extern void execute_3563(char*, char *);
extern void execute_3564(char*, char *);
extern void execute_3565(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[115] = {(funcp)execute_781, (funcp)execute_3558, (funcp)execute_3559, (funcp)execute_3560, (funcp)execute_3547, (funcp)execute_3548, (funcp)execute_3549, (funcp)execute_3550, (funcp)execute_3551, (funcp)execute_3552, (funcp)execute_3553, (funcp)execute_3554, (funcp)execute_3555, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_994, (funcp)execute_796, (funcp)execute_797, (funcp)execute_798, (funcp)execute_786, (funcp)execute_787, (funcp)execute_788, (funcp)execute_789, (funcp)execute_790, (funcp)execute_1431, (funcp)execute_995, (funcp)execute_996, (funcp)execute_997, (funcp)execute_998, (funcp)execute_999, (funcp)execute_1000, (funcp)execute_1001, (funcp)execute_1002, (funcp)execute_1003, (funcp)execute_1004, (funcp)execute_1005, (funcp)execute_1006, (funcp)execute_1007, (funcp)execute_1008, (funcp)execute_1009, (funcp)execute_1010, (funcp)execute_1220, (funcp)execute_1221, (funcp)execute_1432, (funcp)execute_1433, (funcp)execute_1434, (funcp)execute_1435, (funcp)execute_1436, (funcp)execute_1437, (funcp)execute_1438, (funcp)execute_1439, (funcp)execute_1440, (funcp)execute_1441, (funcp)execute_1442, (funcp)execute_1443, (funcp)execute_1444, (funcp)execute_1445, (funcp)execute_1446, (funcp)execute_1447, (funcp)execute_1448, (funcp)execute_1449, (funcp)execute_1450, (funcp)execute_1451, (funcp)execute_1452, (funcp)execute_1453, (funcp)execute_1454, (funcp)execute_1455, (funcp)execute_1456, (funcp)execute_1457, (funcp)execute_1458, (funcp)execute_1459, (funcp)execute_1460, (funcp)execute_1461, (funcp)execute_1462, (funcp)execute_1463, (funcp)execute_1884, (funcp)execute_1885, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_2113, (funcp)execute_2114, (funcp)execute_2115, (funcp)execute_2116, (funcp)execute_2118, (funcp)execute_2119, (funcp)execute_2120, (funcp)execute_2121, (funcp)execute_2570, (funcp)execute_2571, (funcp)execute_2632, (funcp)execute_2693, (funcp)execute_2754, (funcp)execute_2815, (funcp)execute_2876, (funcp)execute_2937, (funcp)execute_2998, (funcp)execute_3059, (funcp)execute_3120, (funcp)execute_3181, (funcp)execute_3242, (funcp)execute_3303, (funcp)execute_3364, (funcp)execute_3425, (funcp)execute_3486, (funcp)execute_2572, (funcp)execute_2573, (funcp)execute_2574, (funcp)execute_2575, (funcp)execute_783, (funcp)execute_784, (funcp)execute_785, (funcp)execute_3561, (funcp)execute_3562, (funcp)execute_3563, (funcp)execute_3564, (funcp)execute_3565, (funcp)vlog_transfunc_eventcallback};
const int NumRelocateId= 115;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/alutestbench_behav/xsim.reloc",  (void **)funcTab, 115);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/alutestbench_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/alutestbench_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/alutestbench_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/alutestbench_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/alutestbench_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
