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
extern void execute_823(char*, char *);
extern void execute_3726(char*, char *);
extern void execute_3727(char*, char *);
extern void execute_3728(char*, char *);
extern void execute_3589(char*, char *);
extern void execute_3620(char*, char *);
extern void execute_3651(char*, char *);
extern void execute_3712(char*, char *);
extern void execute_3713(char*, char *);
extern void execute_3714(char*, char *);
extern void execute_3715(char*, char *);
extern void execute_3716(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_3719(char*, char *);
extern void execute_3720(char*, char *);
extern void execute_3721(char*, char *);
extern void execute_3722(char*, char *);
extern void execute_3723(char*, char *);
extern void execute_3724(char*, char *);
extern void execute_3725(char*, char *);
extern void execute_1036(char*, char *);
extern void execute_838(char*, char *);
extern void execute_839(char*, char *);
extern void execute_840(char*, char *);
extern void execute_828(char*, char *);
extern void execute_829(char*, char *);
extern void execute_830(char*, char *);
extern void execute_831(char*, char *);
extern void execute_832(char*, char *);
extern void execute_1473(char*, char *);
extern void execute_1037(char*, char *);
extern void execute_1038(char*, char *);
extern void execute_1039(char*, char *);
extern void execute_1040(char*, char *);
extern void execute_1041(char*, char *);
extern void execute_1042(char*, char *);
extern void execute_1043(char*, char *);
extern void execute_1044(char*, char *);
extern void execute_1045(char*, char *);
extern void execute_1046(char*, char *);
extern void execute_1047(char*, char *);
extern void execute_1048(char*, char *);
extern void execute_1049(char*, char *);
extern void execute_1050(char*, char *);
extern void execute_1051(char*, char *);
extern void execute_1052(char*, char *);
extern void execute_1262(char*, char *);
extern void execute_1263(char*, char *);
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
extern void execute_1484(char*, char *);
extern void execute_1485(char*, char *);
extern void execute_1486(char*, char *);
extern void execute_1487(char*, char *);
extern void execute_1488(char*, char *);
extern void execute_1489(char*, char *);
extern void execute_1490(char*, char *);
extern void execute_1491(char*, char *);
extern void execute_1492(char*, char *);
extern void execute_1493(char*, char *);
extern void execute_1494(char*, char *);
extern void execute_1495(char*, char *);
extern void execute_1496(char*, char *);
extern void execute_1497(char*, char *);
extern void execute_1498(char*, char *);
extern void execute_1499(char*, char *);
extern void execute_1500(char*, char *);
extern void execute_1501(char*, char *);
extern void execute_1502(char*, char *);
extern void execute_1503(char*, char *);
extern void execute_1504(char*, char *);
extern void execute_1505(char*, char *);
extern void execute_1926(char*, char *);
extern void execute_1927(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_2155(char*, char *);
extern void execute_2156(char*, char *);
extern void execute_2157(char*, char *);
extern void execute_2158(char*, char *);
extern void execute_2160(char*, char *);
extern void execute_2161(char*, char *);
extern void execute_2162(char*, char *);
extern void execute_2163(char*, char *);
extern void execute_2612(char*, char *);
extern void execute_2613(char*, char *);
extern void execute_2674(char*, char *);
extern void execute_2735(char*, char *);
extern void execute_2796(char*, char *);
extern void execute_2857(char*, char *);
extern void execute_2918(char*, char *);
extern void execute_2979(char*, char *);
extern void execute_3040(char*, char *);
extern void execute_3101(char*, char *);
extern void execute_3162(char*, char *);
extern void execute_3223(char*, char *);
extern void execute_3284(char*, char *);
extern void execute_3345(char*, char *);
extern void execute_3406(char*, char *);
extern void execute_3467(char*, char *);
extern void execute_3528(char*, char *);
extern void execute_2614(char*, char *);
extern void execute_2615(char*, char *);
extern void execute_2616(char*, char *);
extern void execute_2617(char*, char *);
extern void execute_3614(char*, char *);
extern void execute_3595(char*, char *);
extern void execute_825(char*, char *);
extern void execute_826(char*, char *);
extern void execute_827(char*, char *);
extern void execute_3729(char*, char *);
extern void execute_3730(char*, char *);
extern void execute_3731(char*, char *);
extern void execute_3732(char*, char *);
extern void execute_3733(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[123] = {(funcp)execute_823, (funcp)execute_3726, (funcp)execute_3727, (funcp)execute_3728, (funcp)execute_3589, (funcp)execute_3620, (funcp)execute_3651, (funcp)execute_3712, (funcp)execute_3713, (funcp)execute_3714, (funcp)execute_3715, (funcp)execute_3716, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_3719, (funcp)execute_3720, (funcp)execute_3721, (funcp)execute_3722, (funcp)execute_3723, (funcp)execute_3724, (funcp)execute_3725, (funcp)execute_1036, (funcp)execute_838, (funcp)execute_839, (funcp)execute_840, (funcp)execute_828, (funcp)execute_829, (funcp)execute_830, (funcp)execute_831, (funcp)execute_832, (funcp)execute_1473, (funcp)execute_1037, (funcp)execute_1038, (funcp)execute_1039, (funcp)execute_1040, (funcp)execute_1041, (funcp)execute_1042, (funcp)execute_1043, (funcp)execute_1044, (funcp)execute_1045, (funcp)execute_1046, (funcp)execute_1047, (funcp)execute_1048, (funcp)execute_1049, (funcp)execute_1050, (funcp)execute_1051, (funcp)execute_1052, (funcp)execute_1262, (funcp)execute_1263, (funcp)execute_1474, (funcp)execute_1475, (funcp)execute_1476, (funcp)execute_1477, (funcp)execute_1478, (funcp)execute_1479, (funcp)execute_1480, (funcp)execute_1481, (funcp)execute_1482, (funcp)execute_1483, (funcp)execute_1484, (funcp)execute_1485, (funcp)execute_1486, (funcp)execute_1487, (funcp)execute_1488, (funcp)execute_1489, (funcp)execute_1490, (funcp)execute_1491, (funcp)execute_1492, (funcp)execute_1493, (funcp)execute_1494, (funcp)execute_1495, (funcp)execute_1496, (funcp)execute_1497, (funcp)execute_1498, (funcp)execute_1499, (funcp)execute_1500, (funcp)execute_1501, (funcp)execute_1502, (funcp)execute_1503, (funcp)execute_1504, (funcp)execute_1505, (funcp)execute_1926, (funcp)execute_1927, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_2155, (funcp)execute_2156, (funcp)execute_2157, (funcp)execute_2158, (funcp)execute_2160, (funcp)execute_2161, (funcp)execute_2162, (funcp)execute_2163, (funcp)execute_2612, (funcp)execute_2613, (funcp)execute_2674, (funcp)execute_2735, (funcp)execute_2796, (funcp)execute_2857, (funcp)execute_2918, (funcp)execute_2979, (funcp)execute_3040, (funcp)execute_3101, (funcp)execute_3162, (funcp)execute_3223, (funcp)execute_3284, (funcp)execute_3345, (funcp)execute_3406, (funcp)execute_3467, (funcp)execute_3528, (funcp)execute_2614, (funcp)execute_2615, (funcp)execute_2616, (funcp)execute_2617, (funcp)execute_3614, (funcp)execute_3595, (funcp)execute_825, (funcp)execute_826, (funcp)execute_827, (funcp)execute_3729, (funcp)execute_3730, (funcp)execute_3731, (funcp)execute_3732, (funcp)execute_3733, (funcp)vlog_transfunc_eventcallback};
const int NumRelocateId= 123;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/alutestbench_behav/xsim.reloc",  (void **)funcTab, 123);

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
