###############################################################################
#
# Run this file on local Linux that has the data
# Do not run it on other computers to avoid unexpected errors
#
###############################################################################
using Pkg.Artifacts

# Artifacts.toml file to manipulate
artifact_toml = joinpath(@__DIR__, "Artifacts.toml");

# Query the 2020_optimal_gm hash from Artifacts.toml
optg_hash = artifact_hash("2020_optimal_gm", artifact_toml);

# need to run this for every new installation, because the calcualted SHA
# differs among computers
if isnothing(optg_hash) || !artifact_exists(optg_hash)
    println("No artifacts found for 2020_optimal_gm, deploy it now...");

    optg_hash = create_artifact() do artifact_dir
        file_loc = "/home/wyujie/Data/OptimalGM/"
        cp(file_loc * "gm_responses.csv" ,
           joinpath(artifact_dir, "gm_responses.csv" ));
    end
    @show optg_hash;

    tar_url  = "https://github.com/Yujie-W/ResearchArtifacts/tree/wyujie/" *
               "2020_optimal_gm/2020_optimal_gm.tar.gz";
    tar_loc  = "2020_optimal_gm.tar.gz";
    tar_hash = archive_artifact(optg_hash, tar_loc);
    @show tar_hash;

    bind_artifact!(artifact_toml, "2020_optimal_gm", optg_hash;
                   download_info=[(tar_url, tar_hash)],
                   lazy=true,
                   force=true);
else
    println("Artifact of 2020_optimal_gm already exists, skip it");
end
