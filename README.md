<div>
<picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-white.png"><img width="100%" alt="edgewise-logo" src="assets/logo.png"/>
</picture>
</div>

<hr>

**EdgeWiseCR** methodology is described and assessed in:

> [Jacopo Massa](https://pages.di.unipi.it/massa), [Stefano Forti](https://pages.di.unipi.it/forti), [Patrizio Dazzi](https://pages.di.unipi.it/dazzi), [Antonio Brogi](https://pages.di.unipi.it/brogi)<br>
> [**Combining Declarative and Linear Programming for Application Management in the Cloud-Edge Continuum**](10.1016/j.future.2025.108224), <br>	
> Future Generation Computer Systems, 2025.

This work investigates the data-aware multi-service application placement problem in Cloud-Edge settings. We previously introduced [_EdgeWise_](https://github.com/di-unipi-socc/edgewise), a hybrid approach that combines declarative programming with Mixed-Integer Linear Programming (MILP) to determine optimal placements that minimise operational costs and unnecessary data transfers. The declarative stage pre-processes infrastructure constraints to improve the efficiency of the MILP solver, achieving optimal placements in terms of operational costs, with significantly reduced execution times. 

In this extended version, we improve the declarative stage with continuous reasoning, presenting **EdgeWiseCR**, which enables the system to reuse existing placements and reduce unnecessary recomputation and service migrations. In addition, we conducted an expanded experimental evaluation considering multiple applications, diverse network topologies, and large-scale infrastructures with dynamic failures. The results show that EdgeWiseCR achieves up to _65% faster execution_ compared to EdgeWise, while preserving placement stability under dynamic conditions.
