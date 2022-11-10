# import Mogrify

defmodule TinyEpub.Handler do
  def handle(path) do
    path
    |> backup
    |> extract
    |> process
    |> cleanup
    |> thanks!
  end

  defp backup(path) do

    File.cd(System.tmp_dir!())
    File.mkdir("TinyEpub")
    File.cd("TinyEpub")
    {_, app_dir} = File.cwd()
    copy(File.dir?(path), path, app_dir)
    app_dir
  end

  defp extract(app_dir) do

    File.cd(app_dir)

    Enum.each(Path.wildcard("#{app_dir}/**/*.{epub}"), fn x ->
      # File.cp(x, Path.join([app_dir, Path.basename(x)]))
      file_base = Path.basename(x, ".epub")
      File.mkdir(file_base)
      :zip.extract(String.to_charlist(x), [{:cwd, Path.join([app_dir, file_base])}])
      File.rm(x)
    end)

    app_dir
  end

  defp process(app_dir) do
    File.cd(app_dir)
    {_, folders} = File.ls()

    Enum.each(folders, fn x ->
      compress(x)
      package(x)
      File.rm_rf(x)
    end)
    app_dir
  end

  defp compress(folder) do
    Enum.each(Path.wildcard("#{folder}/**/*.{jpg,jpeg,png}"), fn x ->
      # %{height: height, width: width} = Fastimage.size(x)
      # image =  Mogrify.open(x) |> Mogrify.resize("#{height * 0.5}x#{width * 0.5}") |> Mogrify.save(in_place: true)
      Mogrify.open(x) |> Mogrify.quality("50") |> Mogrify.save(in_place: true)
    end)
  end

  defp package(folder) do
    files = File.ls!(folder) |> Enum.map(&String.to_charlist/1)
    file_name = Path.basename(folder)
    File.cd!(folder)
    File.cd!("..")
    :zip.create("#{file_name}.epub", files, [{:cwd, file_name}])
  end

  defp copy(true, path, app_dir) do
    # IO.puts ("#{path} is a directory!")
    Enum.each(Path.wildcard("#{path}/**/*.{epub}"), fn x ->
      File.cp(x, Path.join([app_dir, Path.basename(x)]))
    end)
  end

  defp copy(false, path, app_dir) do
    # IO.puts ("#{path} is a file!")
    File.cp(path, Path.join([app_dir, Path.basename(path)]))
  end

  defp cleanup(app_dir) do
    # Path.basename(app_dir)
    File.mkdir_p(Path.join([System.user_home,Path.basename(app_dir)]))
    File.cp_r!(app_dir, Path.join([System.user_home,Path.basename(app_dir)]))
    File.rm_rf(app_dir)
    "Temporary directory is cleaned, you can access the compressed files in your home directory."
  end
  defp thanks!(confirmation) do
    IO.puts(confirmation)
    IO.puts("Thank you for trying this script out!")
  end
end
