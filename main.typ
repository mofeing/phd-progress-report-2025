#[
#set align(center)
= PhD progress report
]

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

=== Reactant.jl & Gordon Bell 2025

For the couple of years, I've been working on Reactant.jl, a library for compilation, automatic differentation and optimization of numerical programs written in Julia.
While I joined the team to accelerate Tensor Network simulations, it has long surpassed these objectives and now serves a much broader purpose.
Billy Moses, the initiator of the project, proposed us to apply to the Gordon Bell award. The Gordon Bell award is given at the Supercomputing (SC) conference to the most relevant high-performance simulation of the year.
The jury not only evaluates the scale of the run (i.e. how many processors were efficiently used in the simulation) but also how hard is to scale the selected problem if the candidate team developed new technology that enabled this simulation and improves over the state of the art.

The selected application to accelerate was some planetary-scale fluid-dynamics simulations of the ocean written in Oceananigans.jl. Billy gathered an international team of over 40 people around and I got in charge of the distributed computing working group.

I'm now retargetting Reactant.jl for quantum physics and Tensor Network simulations, specifically by adding support for linear algebra factorizations. The LU decomposition has already been added and I'm working towards adding the QR and the SVD decompositions, which are fundamental for Tensor Networks. This will not only allow us to compile QR and SVD routines, but also seemlessly offload execution to GPU, distribute across multiple GPUs and nodes in the network, differentiate over them and perform compiler optimizations over them.

=== Work with Fujitsu

As part of my work, I've been kind of managing the software team at my research group.
In particular, I've been developing our software to carry out simulations by members of our team and projects related to companies, like Fujitsu.

Specifically, one of my colleagues developed a VQE for studying the ground state energy of a catalyzer used in the Hydrogen electrolysis reaction. Using the Qiskit simulator and a GPU, it took around 24h to run 6000 iterations.
Using Reactant.jl and MPI with Tenet.jl, we accelerated the VQE training from 24h to 20 minutes. There are some details to keep into account: Qiskit uses statevector simulation while we used exact tensor network contraction, the circuit was shallow, we used automatic differentiation instead of the shift rule and it enabled more parallelism that we were able to exploit with more computational resources.
Despite everything, I think this is a nice achievement. On this line, adding automatic differentiation and distribution of linear algebra factorizations to Reactant.jl would allow us to train VQEs on a scale not tried before.

=== k-local Gradient Descent

One personal project I haven't been able to finish during my PhD is the k-local Gradient Descent technique, described in previous reports.
In short, it consists in contracting the tensors of a Tensor Network by pairs, perform gradient descent, factorize the tensors and repeat the same process but contracting the tensors with others, forming an interleaved contract-factorize pattern.
For a computational point-of-view, this method improves over established method due to its parallelism, and it would help training Tensor Network Machine Learning models on a larger scale.

While studying the parallel TEBD algorithm and the quasi-Vidal gauging through the Belief Propagation technique, I realized that the k-local Gradient Descent is equivalent to these techniques.
First, it is already known that repetitively performing TEBD steps to a Tensor Network and the Belief Propagation technique reaches the same fixed point known as the Bethe-Myers ansatz.
Using a hand-wavy tone, if on each gradient descent step the Tensor Network gives a small step on the its manifold, then the Tensor Network won't almost vary and the message passing style of k-local Gradient Descent will be close to the TEBD with identity operators (i.e. just contract and factorize).
As the optimization progresses, the model should be closer and closer to a minimum and thus the given steps should be smaller, which will emphasize the message passing and thus the canonization.
Keeping the Tensor Network in a canonical form is critical to preserve metric tensor; i.e. if not on canonical form, the metric tensor will change severely which leads to serious convergence problems.
Not only that but the canonical form makes the metric tensor of the manifold be isotropic and thus, we can avoid some common issues on numerical optimization.

Due to some problems with automatic differentiation in my Tensor Network library at the moment and some time contraints, I proposed Jose Pareja to work on this together. Jose is a PhD student at Madrid whose research focuses on Machine Learning methods with Tensor Networks, particularly with applications for differential privacy. He is the author of "tensorkrowch", a Python package for Tensor Network Machine Learning on top of the PyTorch framework.

Jose write the code for the simulations I told him and later we adapted them. The results we obtained for a toy model was that the method works well for small number of sites. But when we scale it, the method diverges quickly. The reason is that while the method ensures canonization if it can perform some initial gradient descent steps until convergence starts, there is no guarantee that these first gradient descent steps will start converging or diverging.
In the case of Tensor Networks, slight variations to norm become exponentially sensitive as we scale the model and thus, we run into numerical problems even with mid-range Tensor Networks (i.e. 50 sites).
Right now, I am trying to fix this by forcing canonization at the very beginning of the optimization and applying some norm-preserving gradient embedding methods (i.e. projecting out the part of the gradients that vary the norm). If we are able to unblock this, I am sure that this method will be used for distributed large-scale optimization of Tensor Networks.

  // - A scheme for loss-informed truncation on TN ML. Conversation with Miles Stoudenmire.

== Data management plan and ethical research considerations

#set text(lang: "ca")
Les línies d'investigació mencionades en aquest pla de recerca no generaran dades sensibles ni a nivell personal (protecció de dades) ni a nivell material (seguretat d’infraestructures, medi-ambient...). En termes de seguretat, totes les dades, codi i documents tindran una copia de seguretat local (disc dur) i una al núvol, protegits amb encriptació convencional (password) així com contra accés remot per mitja dels protocols de firewall de la intranet d’acord amb la política del centre(BSC).

Tota la recerca es desenvolupara d’acord amb el “Codi d’integritat en la re- cerca de la UB”. No es preveuen conflictes ètics en l'execució d’experiments, que seran en la seva totalitat computacions i simulacions amb ordinadors personals o amb les capabilitats HPC del centre. Pel que fa al camp de recerca, els conflictes ètics que es contemplen actualment en la computació quàntica (i la seva simulació) estan relacionats amb el paper del desenvolupament de la tecnologia en les relacions internacionals i l'ús d'algoritmes a gran escala, quedant tots dos casos fora de l’avast de la nostra recerca.

#line(length: 100%)

Signatures:

#v(5em)

Student: Sergio Sánchez Ramírez #h(5%) Supervisor: Artur García Saez #h(5%) Supervisor: Bruno Julia 