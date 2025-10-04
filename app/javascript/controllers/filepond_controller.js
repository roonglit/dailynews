import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from '@rails/activestorage'
import * as FilePond from "filepond"
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';

export default class extends Controller {
  static targets = ["input"]

  connect() {
    if (this.inputTarget) {
      this.inputName = this.inputTarget.name
      // Store reference to the container before FilePond transforms the input
      this.containerElement = this.inputTarget.parentNode
      this.initializeFilePond(
        this.inputTarget.dataset.directUploadUrl
      )
    }
  }

  initializeFilePond(directUploadUrl) {
    FilePond.registerPlugin(FilePondPluginImagePreview);

    const filepond = FilePond.create(this.inputTarget, {
      server: {
        process: (fieldName, file, metadata, load, error, progress, abort, transfer, options) => {
          const upload = new DirectUpload(file, directUploadUrl, {
            directUploadWillStoreFileWithXHR(request) {
              request.upload.addEventListener("progress",
                event => progress(event.lengthComputable, event.loaded, event.total)
              );
            }
          });

          upload.create((error, blob) => {
            if (error) {
              // Handle the error
            } else {
              // Add an appropriately-named hidden input to the form with a
              //  value of blob.signed_id so that the blob ids will be
              //  transmitted in the normal upload flow
              const hiddenField = document.createElement('input')
              hiddenField.setAttribute("type", "hidden");
              hiddenField.setAttribute("value", blob.signed_id);
              hiddenField.name = this.inputName
              this.containerElement.appendChild(hiddenField)

              load(blob.signed_id)
            }
          })

          return {
            abort: () => abort()
          }
        },

        revert: (uniqueFileId, load, error) => {
          // Find and remove any hidden input with value matching uniqueFileId in the same container
          const hiddenInputs = this.containerElement.querySelectorAll(`input[type="hidden"][name="${this.inputName}"]`);
          hiddenInputs.forEach(input => {
            if (input.value === uniqueFileId) {
              input.remove();
            }
          });
          
          load();
        }
      }
    })
  }
}
