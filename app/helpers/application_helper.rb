module ApplicationHelper
  def tag_path(tag)
    if params[:tags] && params[:tags].respond_to?(:map)
      posts_path(tags: params[:tags].map(&:to_i).append(tag.id).uniq)
    else
      posts_path(tags: (Array tag.id))
    end
  end
  
  def remove_tag_path(tag)
    return posts_path unless params[:tags].respond_to?(:map)
    tag_ids = params[:tags].map(&:to_i)
    tag_ids.delete(tag.id)
    tag_ids.empty? ? posts_path : posts_path(tags: tag_ids)
  end
end
