###############################################################################
#
# Run this file on local Linux that has the data
# Do not run it on other computers to avoid unexpected errors
#
###############################################################################
using Pkg.Artifacts
using PkgUtility

# Artifacts.toml file to manipulate
artifact_toml = joinpath(@__DIR__, "Artifacts.toml");




# deploy US 48 states weather data (run this part on server, isdir control)
if isdir("/net/fluo/data1/ftp/XYZT_YW/data")
    deploy_artifact(artifact_toml,
                    "2020_leaf_invest_weather_US_48",
                    "/home/wyujie/Data/USAPixelSites",
                    "/net/fluo/data1/ftp/XYZT_YW/data",
                    ["ftp://fluo.gps.caltech.edu/XYZT_CLIMA_LUT/data"]);
end




# Query the 2020_leaf_invest_weather hash from Artifacts.toml
weat_hash = artifact_hash("2020_leaf_invest_weather", artifact_toml);

# need to run this for every new installation, because the calcualted SHA
# differs among computers
if isnothing(weat_hash) || !artifact_exists(weat_hash)
    println("No artifact found for 2020_leaf_invest_weather, deploying...");

    weat_hash = create_artifact() do artifact_dir
        _if = "/home/wyujie/Data/USAForest20Sites/gs_sample.csv";
        cp(_if, joinpath(artifact_dir, "gs_sample.csv"));
        _if = "/home/wyujie/Data/USAForest20Sites/location.csv";
        cp(_if, joinpath(artifact_dir, "location.csv"));
        for site in ["Durango", "Flagstaff", "Hattiesburg", "Trinity"]
            _if = "/home/wyujie/Data/USAForest20Sites/" * site * "/" * site *
                  "_histo_sim0_GS.csv"
            _of = site * "_histo_sim0_GS.csv"
            cp(_if, joinpath(artifact_dir, _of));
        end
    end
    @show weat_hash;

    tar_url  = "https://github.com/Yujie-W/ResearchArtifacts/tree/wyujie/" *
               "2020_leaf_invest/2020_leaf_invest_weather.tar.gz";
    tar_loc  = "2020_leaf_invest_weather.tar.gz";
    tar_hash = archive_artifact(weat_hash, tar_loc);
    @show tar_hash;

    bind_artifact!(artifact_toml, "2020_leaf_invest_weather", weat_hash;
                   download_info=[(tar_url, tar_hash)],
                   lazy=true,
                   force=true);
else
    println("Artifact of 2020_leaf_invest_weather already exists, skip it");
end




# Query the 2020_leaf_invest_simulation hash from Artifacts.toml
simu_hash = artifact_hash("2020_leaf_invest_simulation", artifact_toml);

# need to run this for every new installation, because the calcualted SHA
# differs among computers
if isnothing(simu_hash) || !artifact_exists(simu_hash)
    println("No artifact found for 2020_leaf_invest_simulation, deploying...");

    simu_hash = create_artifact() do artifact_dir
        _dir = "/home/wyujie/Data/USAForest20Sites"
        _if  = _dir * "/invest_map.csv";
        cp(_if, joinpath(artifact_dir, "invest_map.csv"));
        _if  = _dir * "/sensitivity_analysis.csv";
        cp(_if, joinpath(artifact_dir, "sensitivity_analysis.csv"));
        _if  = _dir * "/sensitivity_analysis_gmax.csv";
        cp(_if, joinpath(artifact_dir, "sensitivity_analysis_gmax.csv"));
        _if  = _dir * "/spp_sperry_2019.csv";
        cp(_if, joinpath(artifact_dir, "spp_sperry_2019.csv"));
    end
    @show simu_hash;

    tar_url  = "https://github.com/Yujie-W/ResearchArtifacts/tree/wyujie/" *
               "2020_leaf_invest/2020_leaf_invest_simulation.tar.gz";
    tar_loc  = "2020_leaf_invest_simulation.tar.gz";
    tar_hash = archive_artifact(simu_hash, tar_loc);
    @show tar_hash;

    bind_artifact!(artifact_toml, "2020_leaf_invest_simulation", simu_hash;
                   download_info=[(tar_url, tar_hash)],
                   lazy=true,
                   force=true);
else
    println("Artifact of 2020_leaf_invest_simulation already exists, skip it");
end
