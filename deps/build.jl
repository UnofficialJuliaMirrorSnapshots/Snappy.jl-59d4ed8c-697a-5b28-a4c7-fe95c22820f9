using BinaryProvider

# This is where all binaries will get installed
const prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__,"usr"))
libsnappy = LibraryProduct(prefix, "libsnappy", :libsnappy)
products = [libsnappy]

# Download binaries from hosted location
bin_prefix = "https://github.com/davidanthoff/SnappyBuilder/releases/download/v1.1.7%2Bbuild.1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64) => ("$bin_prefix/SnappyBuilder.aarch64-linux-gnu.tar.gz", "8cb4b9af85da7efa20bc4787ea16af4b76123d790590bfd447cbe092f123f2f8"),
    Linux(:armv7l) => ("$bin_prefix/SnappyBuilder.arm-linux-gnueabihf.tar.gz", "67469c1ce2391e65c3d9f5f8162f0e14f69ce0e19af0389ad8d77226bf79a922"),
    Linux(:i686) => ("$bin_prefix/SnappyBuilder.i686-linux-gnu.tar.gz", "f34512ca97f500cdaeeea19aeb3e3075b3aa2b4342cf3a5a3788c77eb634f0bd"),
    Windows(:i686) => ("$bin_prefix/SnappyBuilder.i686-w64-mingw32.tar.gz", "53a28428e5c3d75bef1b2ce90b8af8905177b7dae313c8a859afe24c7c9571dd"),
    Linux(:powerpc64le) => ("$bin_prefix/SnappyBuilder.powerpc64le-linux-gnu.tar.gz", "32ecdd9185c2f39e2c95db9e8adb2adf8f251d65c0a8e43c0ee6ec46778045cb"),
    MacOS() => ("$bin_prefix/SnappyBuilder.x86_64-apple-darwin14.tar.gz", "8fe643e462799ce141b4d306427f73b2a373651282cdfabcaeb976e705069b7c"),
    Linux(:x86_64) => ("$bin_prefix/SnappyBuilder.x86_64-linux-gnu.tar.gz", "9a45685503de0db44068126d67f49e241f9013970ddc560cfd7ba17b411dac8c"),
    Windows(:x86_64) => ("$bin_prefix/SnappyBuilder.x86_64-w64-mingw32.tar.gz", "1c13a31c23225b812ee477dffa1fc77d6f501c0a3b65a9920edf5aa4a76f4475"),
)

# First, check to see if we're all satisfied
if any(!satisfied(p; verbose=true) for p in products)
    if haskey(download_info, platform_key())
        # Download and install binaries
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    else
        # If we don't have a BinaryProvider-compatible .tar.gz to download, complain.
        # Alternatively, you could attempt to install from a separate provider,
        # build from source or something more even more ambitious here.
        error("Your platform $(triplet(platform_key())) is not supported by this package!")
    end
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products)