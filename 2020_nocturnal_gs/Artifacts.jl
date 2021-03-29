###############################################################################
#
# Run this file on local Linux that has the data
# Do not run it on other computers to avoid unexpected errors
#
###############################################################################
using Pkg.Artifacts

# Artifacts.toml file to manipulate
artifact_toml = joinpath(@__DIR__, "Artifacts.toml");

# Query the 2020_nocturnal_gs hash from Artifacts.toml
gswn_hash = artifact_hash("2020_nocturnal_gs", artifact_toml);

# need to run this for every new installation, because the calcualted SHA
# differs among computers
if isnothing(gswn_hash) || !artifact_exists(gswn_hash)
    println("No artifacts found for 2020_nocturnal_gs, deploy it now...");

    gswn_hash = create_artifact() do artifact_dir
        file_loc = "/home/wyujie/Data/NocturnalGS/"
        cp(file_loc * "g_co2.csv" , joinpath(artifact_dir, "g_co2.csv" ));
        cp(file_loc * "g_ps.csv"  , joinpath(artifact_dir, "g_ps.csv"  ));
        cp(file_loc * "g_r.csv"   , joinpath(artifact_dir, "g_r.csv"   ));
        cp(file_loc * "g_tem.csv" , joinpath(artifact_dir, "g_tem.csv" ));
        cp(file_loc * "g_time.csv", joinpath(artifact_dir, "g_time.csv"));
        cp(file_loc * "g_vpd.csv" , joinpath(artifact_dir, "g_vpd.csv" ));
    end
    @show gswn_hash;

    tar_url  = "https://github.com/Yujie-W/ResearchArtifacts/tree/wyujie/" *
               "2020_nocturnal_gs/2020_nocturnal_gs.tar.gz";
    tar_loc  = "2020_nocturnal_gs.tar.gz";
    tar_hash = archive_artifact(gswn_hash, tar_loc);
    @show tar_hash;

    bind_artifact!(artifact_toml, "2020_nocturnal_gs", gswn_hash;
                   download_info=[(tar_url, tar_hash)],
                   lazy=true,
                   force=true);
else
    println("Artifact of 2020_nocturnal_gs already exists, skip it");
end
