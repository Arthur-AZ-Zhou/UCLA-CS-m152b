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
extern void execute_801(char*, char *);
extern void execute_3640(char*, char *);
extern void execute_3641(char*, char *);
extern void execute_3642(char*, char *);
extern void execute_3567(char*, char *);
extern void execute_3598(char*, char *);
extern void execute_3629(char*, char *);
extern void execute_3630(char*, char *);
extern void execute_3631(char*, char *);
extern void execute_3632(char*, char *);
extern void execute_3633(char*, char *);
extern void execute_3634(char*, char *);
extern void execute_3635(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_3638(char*, char *);
extern void execute_3639(char*, char *);
extern void execute_1014(char*, char *);
extern void execute_816(char*, char *);
extern void execute_817(char*, char *);
extern void execute_818(char*, char *);
extern void execute_806(char*, char *);
extern void execute_807(char*, char *);
extern void execute_808(char*, char *);
extern void execute_809(char*, char *);
extern void execute_810(char*, char *);
extern void execute_1451(char*, char *);
extern void execute_1015(char*, char *);
extern void execute_1016(char*, char *);
extern void execute_1017(char*, char *);
extern void execute_1018(char*, char *);
extern void execute_1019(char*, char *);
extern void execute_1020(char*, char *);
extern void execute_1021(char*, char *);
extern void execute_1022(char*, char *);
extern void execute_1023(char*, char *);
extern void execute_1024(char*, char *);
extern void execute_1025(char*, char *);
extern void execute_1026(char*, char *);
extern void execute_1027(char*, char *);
extern void execute_1028(char*, char *);
extern void execute_1029(char*, char *);
extern void execute_1030(char*, char *);
extern void execute_1240(char*, char *);
extern void execute_1241(char*, char *);
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
extern void execute_1464(char*, char *);
extern void execute_1465(char*, char *);
extern void execute_1466(char*, char *);
extern void execute_1467(char*, char *);
extern void execute_1468(char*, char *);
extern void execute_1469(char*, char *);
extern void execute_1470(char*, char *);
extern void execute_1471(char*, char *);
extern void execute_1472(char*, char *);
extern void execute_1473(char*, char *);
extern void execute_1474(char*, char *);
extern void execute_1475(char*, char *);
extern void execute_1476(char*, char *);
extern void execute_1477(char*, char *);
extern void execute_1478(char*, char *);
extern void execute_1479(char*, char *);
extern void execute_1480(char*, char *);
extern void execute_1481(char*, char *);
extern void execute_1482(char*, char *);
extern void execute_1483(char*, char *);
extern void execute_1904(char*, char *);
extern void execute_1905(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_2133(char*, char *);
extern void execute_2134(char*, char *);
extern void execute_2135(char*, char *);
extern void execute_2136(char*, char *);
extern void execute_2138(char*, char *);
extern void execute_2139(char*, char *);
extern void execute_2140(char*, char *);
extern void execute_2141(char*, char *);
extern void execute_2590(char*, char *);
extern void execute_2591(char*, char *);
extern void execute_2652(char*, char *);
extern void execute_2713(char*, char *);
extern void execute_2774(char*, char *);
extern void execute_2835(char*, char *);
extern void execute_2896(char*, char *);
extern void execute_2957(char*, char *);
extern void execute_3018(char*, char *);
extern void execute_3079(char*, char *);
extern void execute_3140(char*, char *);
extern void execute_3201(char*, char *);
extern void execute_3262(char*, char *);
extern void execute_3323(char*, char *);
extern void execute_3384(char*, char *);
extern void execute_3445(char*, char *);
extern void execute_3506(char*, char *);
extern void execute_2592(char*, char *);
extern void execute_2593(char*, char *);
extern void execute_2594(char*, char *);
extern void execute_2595(char*, char *);
extern void execute_3592(char*, char *);
extern void execute_3573(char*, char *);
extern void execute_803(char*, char *);
extern void execute_804(char*, char *);
extern void execute_805(char*, char *);
extern void execute_3643(char*, char *);
extern void execute_3644(char*, char *);
extern void execute_3645(char*, char *);
extern void execute_3646(char*, char *);
extern void execute_3647(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[119] = {(funcp)execute_801, (funcp)execute_3640, (funcp)execute_3641, (funcp)execute_3642, (funcp)execute_3567, (funcp)execute_3598, (funcp)execute_3629, (funcp)execute_3630, (funcp)execute_3631, (funcp)execute_3632, (funcp)execute_3633, (funcp)execute_3634, (funcp)execute_3635, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_3638, (funcp)execute_3639, (funcp)execute_1014, (funcp)execute_816, (funcp)execute_817, (funcp)execute_818, (funcp)execute_806, (funcp)execute_807, (funcp)execute_808, (funcp)execute_809, (funcp)execute_810, (funcp)execute_1451, (funcp)execute_1015, (funcp)execute_1016, (funcp)execute_1017, (funcp)execute_1018, (funcp)execute_1019, (funcp)execute_1020, (funcp)execute_1021, (funcp)execute_1022, (funcp)execute_1023, (funcp)execute_1024, (funcp)execute_1025, (funcp)execute_1026, (funcp)execute_1027, (funcp)execute_1028, (funcp)execute_1029, (funcp)execute_1030, (funcp)execute_1240, (funcp)execute_1241, (funcp)execute_1452, (funcp)execute_1453, (funcp)execute_1454, (funcp)execute_1455, (funcp)execute_1456, (funcp)execute_1457, (funcp)execute_1458, (funcp)execute_1459, (funcp)execute_1460, (funcp)execute_1461, (funcp)execute_1462, (funcp)execute_1463, (funcp)execute_1464, (funcp)execute_1465, (funcp)execute_1466, (funcp)execute_1467, (funcp)execute_1468, (funcp)execute_1469, (funcp)execute_1470, (funcp)execute_1471, (funcp)execute_1472, (funcp)execute_1473, (funcp)execute_1474, (funcp)execute_1475, (funcp)execute_1476, (funcp)execute_1477, (funcp)execute_1478, (funcp)execute_1479, (funcp)execute_1480, (funcp)execute_1481, (funcp)execute_1482, (funcp)execute_1483, (funcp)execute_1904, (funcp)execute_1905, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_2133, (funcp)execute_2134, (funcp)execute_2135, (funcp)execute_2136, (funcp)execute_2138, (funcp)execute_2139, (funcp)execute_2140, (funcp)execute_2141, (funcp)execute_2590, (funcp)execute_2591, (funcp)execute_2652, (funcp)execute_2713, (funcp)execute_2774, (funcp)execute_2835, (funcp)execute_2896, (funcp)execute_2957, (funcp)execute_3018, (funcp)execute_3079, (funcp)execute_3140, (funcp)execute_3201, (funcp)execute_3262, (funcp)execute_3323, (funcp)execute_3384, (funcp)execute_3445, (funcp)execute_3506, (funcp)execute_2592, (funcp)execute_2593, (funcp)execute_2594, (funcp)execute_2595, (funcp)execute_3592, (funcp)execute_3573, (funcp)execute_803, (funcp)execute_804, (funcp)execute_805, (funcp)execute_3643, (funcp)execute_3644, (funcp)execute_3645, (funcp)execute_3646, (funcp)execute_3647, (funcp)vlog_transfunc_eventcallback};
const int NumRelocateId= 119;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/alutestbench_behav/xsim.reloc",  (void **)funcTab, 119);

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
