function dw = plasticity_covariancerule(beta, u_presynaptic, u_postsynaptic, u0_presynaptic, u0_postsynaptic)

dw = beta*(u_postsynaptic - u0_postsynaptic).*(u_presynaptic - u0_presynaptic);