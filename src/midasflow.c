#include <R.h>
#include <Rinternals.h>
#include <midas.h>

SEXP call_mefa(SEXP dir_path_sexp, SEXP dir_opts_sexp, SEXP encoding_sexp,
               SEXP accum_path_sexp, SEXP use_lessmem_sexp,
               SEXP compress_output_sexp, SEXP num_threads_sexp)
{
    const char *dir_path =
        dir_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(dir_path_sexp, 0));
    const char *dir_opts =
        dir_opts_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(dir_opts_sexp, 0));
    const char *encoding =
        encoding_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(encoding_sexp, 0));
    const char *accum_path =
        accum_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(accum_path_sexp, 0));
    int use_lessmem = INTEGER(use_lessmem_sexp)[0];
    int compress_output = INTEGER(compress_output_sexp)[0];
    int num_threads = INTEGER(num_threads_sexp)[0];

    return
        ScalarInteger(mefa
                      (dir_path, dir_opts, encoding, accum_path, use_lessmem,
                       compress_output, num_threads));
}

SEXP call_meshed(SEXP dir_path_sexp, SEXP dir_opts_sexp, SEXP encoding_sexp,
                 SEXP outlets_path_sexp, SEXP outlets_layer_sexp,
                 SEXP outlets_opts_sexp, SEXP id_col_sexp,
                 SEXP output_path_sexp, SEXP hier_path_sexp,
                 SEXP use_lessmem_sexp, SEXP compress_output_sexp,
                 SEXP save_outlets_sexp, SEXP num_threads_sexp
#ifdef LOOP_THEN_TASK
                 , SEXP tracing_stack_size_sexp
#endif
    )
{
    const char *dir_path =
        dir_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(dir_path_sexp, 0));
    const char *dir_opts =
        dir_opts_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(dir_opts_sexp, 0));
    const char *encoding =
        encoding_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(encoding_sexp, 0));
    const char *outlets_path =
        outlets_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(outlets_path_sexp, 0));
    const char *outlets_layer =
        outlets_layer_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(outlets_layer_sexp, 0));
    const char *outlets_opts =
        outlets_opts_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(outlets_opts_sexp, 0));
    const char *id_col =
        id_col_sexp == R_NilValue ? NULL : CHAR(STRING_ELT(id_col_sexp, 0));
    const char *output_path =
        output_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(output_path_sexp, 0));
    const char *hier_path =
        hier_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(hier_path_sexp, 0));
    int use_lessmem = INTEGER(use_lessmem_sexp)[0];
    int compress_output = INTEGER(compress_output_sexp)[0];
    int save_outlets = INTEGER(save_outlets_sexp)[0];
    int num_threads = INTEGER(num_threads_sexp)[0];

#ifdef LOOP_THEN_TASK
    int tracing_stack_size = INTEGER(tracing_stack_size_sexp)[0];
#endif

    return
        ScalarInteger(meshed
                      (dir_path, dir_opts, encoding, outlets_path,
                       outlets_layer, outlets_opts, id_col, output_path,
                       hier_path, use_lessmem, compress_output, save_outlets,
                       num_threads
#ifdef LOOP_THEN_TASK
                       , tracing_stack_size
#endif
                      ));
}

SEXP call_melfp(SEXP dir_path_sexp, SEXP dir_opts_sexp, SEXP encoding_sexp,
                SEXP outlets_path_sexp, SEXP outlets_layer_sexp,
                SEXP outlets_opts_sexp, SEXP id_col_sexp,
                SEXP output_path_sexp, SEXP oid_col_sexp, SEXP lfp_name_sexp,
                SEXP heads_name_sexp, SEXP coors_path_sexp,
                SEXP find_full_sexp, SEXP use_lessmem_sexp,
                SEXP save_outlets_sexp, SEXP num_threads_sexp
#ifdef LOOP_THEN_TASK
                , SEXP tracing_stack_size_sexp
#endif
    )
{
    const char *dir_path =
        dir_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(dir_path_sexp, 0));
    const char *dir_opts =
        dir_opts_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(dir_opts_sexp, 0));
    const char *encoding =
        encoding_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(encoding_sexp, 0));
    const char *outlets_path =
        outlets_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(outlets_path_sexp, 0));
    const char *outlets_layer =
        outlets_layer_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(outlets_layer_sexp, 0));
    const char *outlets_opts =
        outlets_opts_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(outlets_opts_sexp, 0));
    const char *id_col =
        id_col_sexp == R_NilValue ? NULL : CHAR(STRING_ELT(id_col_sexp, 0));
    const char *output_path =
        output_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(output_path_sexp, 0));
    const char *oid_col =
        oid_col_sexp == R_NilValue ? NULL : CHAR(STRING_ELT(oid_col_sexp, 0));
    const char *lfp_name =
        lfp_name_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(lfp_name_sexp, 0));
    const char *heads_name =
        heads_name_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(heads_name_sexp, 0));
    const char *coors_path =
        coors_path_sexp ==
        R_NilValue ? NULL : CHAR(STRING_ELT(coors_path_sexp, 0));
    int find_full = INTEGER(find_full_sexp)[0];
    int use_lessmem = INTEGER(use_lessmem_sexp)[0];
    int save_outlets = INTEGER(save_outlets_sexp)[0];
    int num_threads = INTEGER(num_threads_sexp)[0];

#ifdef LOOP_THEN_TASK
    int tracing_stack_size = INTEGER(tracing_stack_size_sexp)[0];
#endif

    return
        ScalarInteger(melfp
                      (dir_path, dir_opts, encoding, outlets_path,
                       outlets_layer, outlets_opts, id_col, output_path,
                       oid_col, lfp_name, heads_name, coors_path, find_full,
                       use_lessmem, save_outlets, num_threads
#ifdef LOOP_THEN_TASK
                       , tracing_stack_size
#endif
                      ));
}
