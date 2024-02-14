import os
from huggingface_hub import HfApi, HfFolder, create_repo
from requests.exceptions import HTTPError

# Retrieve the Hugging Face API token from the environment
repo_name = os.getenv("HF_REPO_NAME")
folder_path = os.getenv("OUTPUT_DIR")
hf_token = os.getenv("HF_TOKEN")
assert(repo_name)
assert(folder_path)
assert(hf_token)

# Initialize the Hugging Face API
api = HfApi()

# Log in using the API token
HfFolder.save_token(hf_token)

# Get the email of the authenticated user (optional, for demonstration)
user_info = api.whoami(hf_token)
print(f"Logged in as {user_info['email']}")

# Create repo if not exists:
try:
    api.repo_info(repo_id=repo_name)
except HTTPError as e:
    if e.response.status_code == 404:
        create_repo(repo_name, repo_type="model")
    else:
        raise  # Re-raise the exception for any other HTTP errors

# Upload the folder contents to the specified repository
print(f"Folder uploading to: https://huggingface.co/{repo_name}")
api.upload_folder(
    token=hf_token,
    repo_id=repo_name,
    folder_path=folder_path,
    repo_type="model",
    multi_commits=True,
    multi_commits_verbose=True,
)
