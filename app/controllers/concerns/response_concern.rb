module ResponseConcern
  extend ActiveSupport::Concern

  def render_created(content, message: '', &block)
    render_response(content, :created, message: message, &block)
  end

  def render_unproccessable(content, message: '', &block)
    render_response(content, :unprocessable_entity, message: message, &block)
  end

  def render_response(content, status = :ok, message: '')
    if block_given?
      yield(content, status)
    else
      if content.is_a? ApplicationRecord 
        render json: {
          message: message || status_message(status),
          "#{content.class.name.downcase}": content
        }, status: status
      else
        render json: {
          message: message || status_message(status),
        }.merge(content), status: status
      end
    end
  end

  private

  def status_message(status)
    {
      created: 'Successfully created',
      ok: 'Successfully processed',
      unprocessable_entity: 'Could not process request',
      bad_request: 'Bad request',
    }[status]
  end
end
