import os


def generate_markdown_toc(root_dir, exclude_dirs=None):
    if exclude_dirs is None:
        exclude_dirs = ['.git', 'Image', '全面解读PostgreSQL和Greenplum的Hash%20Join']

    toc = []

    for dirpath, dirnames, filenames in os.walk(root_dir):
        # 排除指定的目录
        dirnames[:] = [d for d in dirnames if d not in exclude_dirs]

        level = dirpath.replace(root_dir, "").count(os.sep)
        indent = '  ' * level

        # 文件夹条目
        folder_name = os.path.basename(dirpath) or "."
        toc.append(
            f"{indent}- [{folder_name}]({dirpath.replace(' ', '%20')}/)")

        for filename in filenames:
            # 文件条目
            file_path = os.path.join(dirpath, filename).replace(' ', '%20')
            toc.append(f"{indent}  - [{filename}]({file_path})")

    return "\n".join(toc)


if __name__ == "__main__":
    root_directory = '.'  # 根目录为当前目录
    exclude_directories = ['.git', 'Image']  # 排除的目录列表
    markdown_toc = generate_markdown_toc(root_directory, exclude_directories)

    with open("DIRECTORY.md", "w") as f:
        f.write("# Project Directory Structure\n\n")
        f.write(markdown_toc)

    print("Markdown TOC generated successfully in DIRECTORY.md")
