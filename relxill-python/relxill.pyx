from libcpp.vector cimport vector


cdef extern from 'relxill/LocalModel.h':
    '#undef READONLY'
    cdef enum class ModelName:
        relline
        relline_lp
        relconv
        relconv_lp
        relxill
        relxillNS
        relxillCO
        relxillCp
        relxilllp
        relxilllpCp
        relxilllpion
        relxilllpionCp
        relxilllpAlpha
        xillver
        xillverCp
        xillverNS
        xillverCO
        xillverD
        relxillD
        relxilllpD
        relxillBB

    void c_xspec_C_wrapper_eval_model 'xspec_C_wrapper_eval_model' (ModelName, double *, double *, int, double *) except +


cdef xspec_C_wrapper_eval_model(ModelName model_name):
    def model(vector[double] energy, vector[double] parameter, flux):
        cdef vector[double] cflux = vector[double](energy.size() - 1)

        for i in range(cflux.size()):
            cflux[i] = flux[i]

        c_xspec_C_wrapper_eval_model(model_name, parameter.data(), cflux.data(), cflux.size(), energy.data())

        for i in range(cflux.size()):
            flux[i] = cflux[i]

    return model


relline = xspec_C_wrapper_eval_model(ModelName.relline)
relconv = xspec_C_wrapper_eval_model(ModelName.relconv)
relline_lp = xspec_C_wrapper_eval_model(ModelName.relline_lp)
relconv_lp = xspec_C_wrapper_eval_model(ModelName.relconv_lp)
relxill = xspec_C_wrapper_eval_model(ModelName.relxill)
relxilllp = xspec_C_wrapper_eval_model(ModelName.relxilllp)
xillver = xspec_C_wrapper_eval_model(ModelName.xillver)
xillverCp = xspec_C_wrapper_eval_model(ModelName.xillverCp)
relxillCp = xspec_C_wrapper_eval_model(ModelName.relxillCp)
relxilllpCp = xspec_C_wrapper_eval_model(ModelName.relxilllpCp)
xillverNS = xspec_C_wrapper_eval_model(ModelName.xillverNS)
relxillNS = xspec_C_wrapper_eval_model(ModelName.relxillNS)


class devel:
    xillverCO = xspec_C_wrapper_eval_model(ModelName.xillverCO)
    relxillCO = xspec_C_wrapper_eval_model(ModelName.relxillCO)
    relxillBB = xspec_C_wrapper_eval_model(ModelName.relxillBB)
    relxilllpAlpha = xspec_C_wrapper_eval_model(ModelName.relxilllpAlpha)
