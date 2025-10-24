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
extern void execute_893(char*, char *);
extern void execute_4048(char*, char *);
extern void execute_4049(char*, char *);
extern void execute_4050(char*, char *);
extern void execute_3774(char*, char *);
extern void execute_3780(char*, char *);
extern void execute_3786(char*, char *);
extern void execute_3797(char*, char *);
extern void execute_3941(char*, char *);
extern void execute_3972(char*, char *);
extern void execute_4033(char*, char *);
extern void execute_4034(char*, char *);
extern void execute_4035(char*, char *);
extern void execute_4036(char*, char *);
extern void execute_4037(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_4040(char*, char *);
extern void execute_4041(char*, char *);
extern void execute_4042(char*, char *);
extern void execute_4043(char*, char *);
extern void execute_4044(char*, char *);
extern void execute_4045(char*, char *);
extern void execute_4046(char*, char *);
extern void execute_4047(char*, char *);
extern void execute_1106(char*, char *);
extern void execute_908(char*, char *);
extern void execute_909(char*, char *);
extern void execute_910(char*, char *);
extern void execute_898(char*, char *);
extern void execute_899(char*, char *);
extern void execute_900(char*, char *);
extern void execute_901(char*, char *);
extern void execute_902(char*, char *);
extern void execute_1543(char*, char *);
extern void execute_1107(char*, char *);
extern void execute_1108(char*, char *);
extern void execute_1109(char*, char *);
extern void execute_1110(char*, char *);
extern void execute_1111(char*, char *);
extern void execute_1112(char*, char *);
extern void execute_1113(char*, char *);
extern void execute_1114(char*, char *);
extern void execute_1115(char*, char *);
extern void execute_1116(char*, char *);
extern void execute_1117(char*, char *);
extern void execute_1118(char*, char *);
extern void execute_1119(char*, char *);
extern void execute_1120(char*, char *);
extern void execute_1121(char*, char *);
extern void execute_1122(char*, char *);
extern void execute_1332(char*, char *);
extern void execute_1333(char*, char *);
extern void execute_1544(char*, char *);
extern void execute_1545(char*, char *);
extern void execute_1546(char*, char *);
extern void execute_1547(char*, char *);
extern void execute_1548(char*, char *);
extern void execute_1549(char*, char *);
extern void execute_1550(char*, char *);
extern void execute_1551(char*, char *);
extern void execute_1552(char*, char *);
extern void execute_1553(char*, char *);
extern void execute_1554(char*, char *);
extern void execute_1555(char*, char *);
extern void execute_1556(char*, char *);
extern void execute_1557(char*, char *);
extern void execute_1558(char*, char *);
extern void execute_1559(char*, char *);
extern void execute_1560(char*, char *);
extern void execute_1561(char*, char *);
extern void execute_1562(char*, char *);
extern void execute_1563(char*, char *);
extern void execute_1564(char*, char *);
extern void execute_1565(char*, char *);
extern void execute_1566(char*, char *);
extern void execute_1567(char*, char *);
extern void execute_1568(char*, char *);
extern void execute_1569(char*, char *);
extern void execute_1570(char*, char *);
extern void execute_1571(char*, char *);
extern void execute_1572(char*, char *);
extern void execute_1573(char*, char *);
extern void execute_1574(char*, char *);
extern void execute_1575(char*, char *);
extern void execute_1996(char*, char *);
extern void execute_1997(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_2225(char*, char *);
extern void execute_2226(char*, char *);
extern void execute_2227(char*, char *);
extern void execute_2228(char*, char *);
extern void execute_2230(char*, char *);
extern void execute_2231(char*, char *);
extern void execute_2232(char*, char *);
extern void execute_2233(char*, char *);
extern void execute_2795(char*, char *);
extern void execute_2796(char*, char *);
extern void execute_2797(char*, char *);
extern void execute_2778(char*, char *);
extern void execute_2779(char*, char *);
extern void execute_2780(char*, char *);
extern void execute_2781(char*, char *);
extern void execute_2782(char*, char *);
extern void execute_2783(char*, char *);
extern void execute_2784(char*, char *);
extern void execute_2785(char*, char *);
extern void execute_2786(char*, char *);
extern void execute_2787(char*, char *);
extern void execute_2788(char*, char *);
extern void execute_2789(char*, char *);
extern void execute_2790(char*, char *);
extern void execute_2791(char*, char *);
extern void execute_2792(char*, char *);
extern void execute_2793(char*, char *);
extern void execute_2794(char*, char *);
extern void execute_2687(char*, char *);
extern void execute_2798(char*, char *);
extern void execute_2859(char*, char *);
extern void execute_2920(char*, char *);
extern void execute_2981(char*, char *);
extern void execute_3042(char*, char *);
extern void execute_3103(char*, char *);
extern void execute_3164(char*, char *);
extern void execute_3225(char*, char *);
extern void execute_3286(char*, char *);
extern void execute_3347(char*, char *);
extern void execute_3408(char*, char *);
extern void execute_3469(char*, char *);
extern void execute_3530(char*, char *);
extern void execute_3591(char*, char *);
extern void execute_3652(char*, char *);
extern void execute_3713(char*, char *);
extern void execute_2799(char*, char *);
extern void execute_2800(char*, char *);
extern void execute_2801(char*, char *);
extern void execute_2802(char*, char *);
extern void execute_3935(char*, char *);
extern void execute_895(char*, char *);
extern void execute_896(char*, char *);
extern void execute_897(char*, char *);
extern void execute_4051(char*, char *);
extern void execute_4052(char*, char *);
extern void execute_4053(char*, char *);
extern void execute_4054(char*, char *);
extern void execute_4055(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[146] = {(funcp)execute_893, (funcp)execute_4048, (funcp)execute_4049, (funcp)execute_4050, (funcp)execute_3774, (funcp)execute_3780, (funcp)execute_3786, (funcp)execute_3797, (funcp)execute_3941, (funcp)execute_3972, (funcp)execute_4033, (funcp)execute_4034, (funcp)execute_4035, (funcp)execute_4036, (funcp)execute_4037, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_4040, (funcp)execute_4041, (funcp)execute_4042, (funcp)execute_4043, (funcp)execute_4044, (funcp)execute_4045, (funcp)execute_4046, (funcp)execute_4047, (funcp)execute_1106, (funcp)execute_908, (funcp)execute_909, (funcp)execute_910, (funcp)execute_898, (funcp)execute_899, (funcp)execute_900, (funcp)execute_901, (funcp)execute_902, (funcp)execute_1543, (funcp)execute_1107, (funcp)execute_1108, (funcp)execute_1109, (funcp)execute_1110, (funcp)execute_1111, (funcp)execute_1112, (funcp)execute_1113, (funcp)execute_1114, (funcp)execute_1115, (funcp)execute_1116, (funcp)execute_1117, (funcp)execute_1118, (funcp)execute_1119, (funcp)execute_1120, (funcp)execute_1121, (funcp)execute_1122, (funcp)execute_1332, (funcp)execute_1333, (funcp)execute_1544, (funcp)execute_1545, (funcp)execute_1546, (funcp)execute_1547, (funcp)execute_1548, (funcp)execute_1549, (funcp)execute_1550, (funcp)execute_1551, (funcp)execute_1552, (funcp)execute_1553, (funcp)execute_1554, (funcp)execute_1555, (funcp)execute_1556, (funcp)execute_1557, (funcp)execute_1558, (funcp)execute_1559, (funcp)execute_1560, (funcp)execute_1561, (funcp)execute_1562, (funcp)execute_1563, (funcp)execute_1564, (funcp)execute_1565, (funcp)execute_1566, (funcp)execute_1567, (funcp)execute_1568, (funcp)execute_1569, (funcp)execute_1570, (funcp)execute_1571, (funcp)execute_1572, (funcp)execute_1573, (funcp)execute_1574, (funcp)execute_1575, (funcp)execute_1996, (funcp)execute_1997, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_2225, (funcp)execute_2226, (funcp)execute_2227, (funcp)execute_2228, (funcp)execute_2230, (funcp)execute_2231, (funcp)execute_2232, (funcp)execute_2233, (funcp)execute_2795, (funcp)execute_2796, (funcp)execute_2797, (funcp)execute_2778, (funcp)execute_2779, (funcp)execute_2780, (funcp)execute_2781, (funcp)execute_2782, (funcp)execute_2783, (funcp)execute_2784, (funcp)execute_2785, (funcp)execute_2786, (funcp)execute_2787, (funcp)execute_2788, (funcp)execute_2789, (funcp)execute_2790, (funcp)execute_2791, (funcp)execute_2792, (funcp)execute_2793, (funcp)execute_2794, (funcp)execute_2687, (funcp)execute_2798, (funcp)execute_2859, (funcp)execute_2920, (funcp)execute_2981, (funcp)execute_3042, (funcp)execute_3103, (funcp)execute_3164, (funcp)execute_3225, (funcp)execute_3286, (funcp)execute_3347, (funcp)execute_3408, (funcp)execute_3469, (funcp)execute_3530, (funcp)execute_3591, (funcp)execute_3652, (funcp)execute_3713, (funcp)execute_2799, (funcp)execute_2800, (funcp)execute_2801, (funcp)execute_2802, (funcp)execute_3935, (funcp)execute_895, (funcp)execute_896, (funcp)execute_897, (funcp)execute_4051, (funcp)execute_4052, (funcp)execute_4053, (funcp)execute_4054, (funcp)execute_4055, (funcp)vlog_transfunc_eventcallback};
const int NumRelocateId= 146;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/alutestbench_behav/xsim.reloc",  (void **)funcTab, 146);

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
