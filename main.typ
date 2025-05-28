= Progress report

=== JuliaCon 2024 at Eindhoven: Extrae.jl

Continuing from my last report, first remarkable thing was going to the JuliaCon 2024 conference at Eindhoven. There I presented my work on the Extrae.jl, a Julia package that interfaces with the Extrae profiler developed at BSC and used extensively in supercomputers. While not directly related to quantum physics, this type of software is critical to analyze the performance bottlenecks of our simulations in high-performance clusters. Besides, visiting JuliaCon is always a enriching event as most of the participants are academics or researchers. In particular, some of the most used Tensor Networks software (ITensors.jl and TensorKit.jl) are developed in Julia and it serves as a secondary meeting point for Tensor Network researchers.

It was during this event that I found Joey Tindall, a postdoctoral researcher of the Flatiron Institute in New York who works on Tensor Networks and recently published several interesting results on Belief Propagation techniques for Tensor Networks. I had tried, with no success, applying to the Flatiron PhD internship program, where we had hoped to start some collaboration. After this encounter and speaking with Artur, my supervisor, we dedicated some project money to go on a research stay for a month and a half to the Flatiron Institute - Center for Computational Quantum Physics (CCQ).

=== Research stay at Flatiron Institute - CCQ

At the Flatiron Institute, they develop ITensors.jl, one of the most used Tensor Networks used libraries. While the software I develop and theirs are rivalling, we always have advocate for integration. The first thing I did here was to develop some extensions to both's software to be able to convert the code from one library to the other. This should make each other's software interoperable at some extent.

The second thing I worked on was trying to extend Belief Propagation on Tensor Network techniques (BP TN) to higher-rank approximations. The problem of BP TN is that it is a rank-1 approximation of the environment of a Tensor Network around a tensor, and even if it's quick to compute, there is no way to increase the approximation order. In some sense, BP TN finds a quick product state approximation of the environment and we don't know how find more terms to such approximation.

The approach Joey and I started to discuss was to use an antiprojection (a.k.a. deflation) scheme to restart the approximation with the first approximation removed. This scheme is similar to the eigendecomposition of a matrix using the power method and then deflating the matrix with the most dominant eigenvector to find the next dominant eigenvector, and so on.

This is numerically sensitive and we ran into several problems.
After several tries, I found out that it wasn't working because one of the requirements of this method is that the objects to be treated must be positive, semi-definite maps (or multimaps in the case of tensors). This requirement is valid on Tensor Networks representing expectation values. The problem is that the environment around a tensor in such Tensor Network is most probably not gonna be positive, semi-definite because the product of positive, semi-definite maps doesn't need to preserve that property. As a consequence, our environments had complex eigenvalues which are known to be numerically extremely sensitive.
At the same time, some alternatives approaches appeared on literature which seem to be more promising and we are shifting towards using them on conjunction or alone for Tensor Network techniques.

=== Work with Fujitsu

...

Using Reactant.jl and MPI with Tenet.jl, we accelerated the VQE training from 24h to 20 minutes.

  - Automatic Differentiation of a shallow VQE
  - Distributed TEBD (with Jofre)
  - Simple update and tensor contraction on GPU

=== Reactant.jl & Gordon Bell 2025

=== k-local Gradient Descent

  - Discovery: k-local Gradient Descent is Vidal gauging
  - Roadblock: On larger Tensor Networks, applying the derivatives directly leads to a larger change in the norm of the state; i.e. the Tensor Network becomes exponentially sensitive.
  - A scheme for loss-informed truncation on TN ML. Conversation with Miles Stoudenmire.

=== Restart

=== Quadrature project

== Data management plan and ethical research considerations

#set text(lang: "ca")
Les línies d'investigació mencionades en aquest pla de recerca no generaran dades sensibles ni a nivell personal (protecció de dades) ni a nivell material (seguretat d’infraestructures, medi-ambient...). En termes de seguretat, totes les dades, codi i documents tindran una copia de seguretat local (disc dur) i una al núvol, protegits amb encriptació convencional (password) així com contra accés remot per mitja dels protocols de firewall de la intranet d’acord amb la política del centre(BSC).

Tota la recerca es desenvolupara d’acord amb el “Codi d’integritat en la re- cerca de la UB”. No es preveuen conflictes ètics en l'execució d’experiments, que seran en la seva totalitat computacions i simulacions amb ordinadors personals o amb les capabilitats HPC del centre. Pel que fa al camp de recerca, els conflictes ètics que es contemplen actualment en la computació quàntica (i la seva simulació) estan relacionats amb el paper del desenvolupament de la tecnologia en les relacions internacionals i l'ús d'algoritmes a gran escala, quedant tots dos casos fora de l’avast de la nostra recerca.

#line(length: 100%)

Signatures:

#v(5em)

Student: Sergio Sánchez Ramírez #h(5%) Supervisor: Artur García Saez #h(5%) Supervisor: Bruno Julia 