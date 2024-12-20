#!/usr/bin/env python3
import os
import yaml
import logging

from jinja2 import Environment, PackageLoader, select_autoescape

logging.basicConfig(level=logging.INFO)

repo_owner = os.getenv("REPO_OWNER") or os.getenv(
    "GITHUB_REPOSITORY_OWNER", "default_owner"
)
repo_name = os.getenv("REPO_NAME") or os.getenv("GITHUB_REPOSITORY", "default_repo")

env = Environment(loader=PackageLoader("render-readme"), autoescape=select_autoescape())


def load_metadata(file_path):
    try:
        with open(file_path, "r") as f:
            return yaml.safe_load(f)
    except yaml.YAMLError as e:
        logging.error(f"Error loading YAML file {file_path}: {e}")
    except FileNotFoundError:
        logging.error(f"File {file_path} not found.")
    return None


def process_metadata(apps_dir):
    app_images = []
    for subdir, _, files in os.walk(apps_dir):
        if "metadata.yaml" not in files:
            continue  # Skip if metadata file not found

        meta = load_metadata(os.path.join(subdir, "metadata.yaml"))
        if not meta:
            continue  # Skip if metadata couldn't be loaded

        # Iterate through the channels and build image metadata
        for channel in meta.get("channels", []):
            name = (
                meta["app"]
                if channel.get("stable", False)
                else f"{meta['app']}-{channel['name']}"
            )
            image = {
                "name": name,
                "channel": channel["name"],
                "html_url": f"https://github.com/{repo_owner}/containers/pkgs/container/{name}",
                "owner": repo_owner,
            }
            app_images.append(image)
            logging.info(f"Added image {name} from channel {channel['name']}")
    return app_images


if __name__ == "__main__":
    apps_dir = "./apps"
    app_images = process_metadata(apps_dir)

    try:
        template = env.get_template("README.md.j2")
        with open("./README.md", "w") as f:
            f.write(template.render(app_images=app_images))
        logging.info("README.md successfully generated.")
    except Exception as e:
        logging.error(f"Error rendering template: {e}")
