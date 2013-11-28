class Upload < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
end
