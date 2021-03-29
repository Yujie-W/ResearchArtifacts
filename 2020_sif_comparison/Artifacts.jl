###############################################################################
#
# Run this file on the FTP server to set up Artifacts
#
###############################################################################
using Pkg.Artifacts




# Artifacts.toml file to manipulate
artifact_toml = joinpath(@__DIR__, "Artifacts.toml");




# FTP url for the datasets
git_url = "https://github.com/Yujie-W/ResearchArtifacts/raw/wyujie/" *
          "2020_sif_comparison";




# function to create artifact
"""
    deploy_artifact(files::Array{String,1},
                    art_name::String,
                    data_folder::String,
                    art_folder::String,
                    new_files::Array{String,1})

Deploy the artifact, given
- `files` Array of file names
- `art_name` Artifact identity
- `data_folder` Optional. Path to original files
- `new_files` Optional. New file names
"""
function deploy_artifact(
            files::Array{String,1},
            art_name::String,
            data_folder::String,
            new_files::Array{String,1} = files
)
    # querry whether the artifact exists
    art_hash = artifact_hash(art_name, artifact_toml);

    # create artifact
    if isnothing(art_hash) || !artifact_exists(art_hash)
        println("\nArtifact ", art_name, " not found, deploy it now...");

        art_hash = create_artifact() do artifact_dir
            for i in eachindex(files)
                _in   = files[i];
                _out  = new_files[i];
                _path = joinpath(data_folder, _in);
                println("Copying file ", _in);
                cp(_path, joinpath(artifact_dir, _out));
            end
        end
        @show art_hash;

        tar_git  = "$(git_url)/$(art_name).tar.gz";
        tar_loc  = "$(art_name).tar.gz";
        println("Compressing artifact...");
        tar_hash = archive_artifact(art_hash, tar_loc);
        @show tar_hash;

        download_info = [(tar_git, tar_hash)];
        bind_artifact!(artifact_toml, art_name, art_hash;
                       download_info=download_info,
                       lazy=true,
                       force=true);
    else
        println("\nArtifact ", art_name, " already exists, skip it");
    end

    return nothing
end

deploy_artifact(["russ_data.csv"],
                "2020_sif_comparison",
                "/home/wyujie/Data/SIFComarison");
