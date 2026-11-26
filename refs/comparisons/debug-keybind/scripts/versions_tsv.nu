def main [infile: string, outfile: string, loader: string, gv: string] {
  open $infile
  | where {|v| ($v.loaders | any {|l| $l == $loader}) and ($v.game_versions | any {|g| $g == $gv}) }
  | each {|v| {
      version_number: $v.version_number,
      name: $v.name,
      type: $v.version_type,
      game_versions: ($v.game_versions | str join ","),
      published: $v.date_published,
      downloads: $v.downloads,
      required_deps: ($v.dependencies | where dependency_type == "required" | each {|d| $d.project_id} | str join ","),
      file: ($v.files | first | get filename),
      size: ($v.files | first | get size),
      sha1: ($v.files | first | get hashes.sha1)
    } }
  | sort-by published --reverse
  | to tsv
  | save -f $outfile
}
