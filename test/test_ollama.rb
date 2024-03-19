# frozen_string_literal: true

require "test_helper"

class TestOllama < Minitest::Test
  def setup
    @ollama = Ollama::Client.new
    @base_url = "http://localhost:11434"
  end

  def test_that_it_has_a_version_number
    refute_nil ::Ollama::VERSION
  end

  def test_models_list
    stub_request(:get, endpoint("/api/tags")).to_return(body: JSON.generate(
      "models" => [
        {
          "name" => "dummy",
          "model" => "dummy",
          "size" => 0,
          "digest" => "digest",
          "details" => {
            "parent_model" => "",
            "format" => "format",
            "family" => "family",
            "families" => [ "family" ],
            "parameter_size" => "parameter_size",
            "quantization_level" => "quantization_level"
          }
        }
      ]
    ))

    response = @ollama.models.list
    assert_equal response.result["models"].first["model"], "dummy"
  end

  def test_models_pull
    stub_request(:post, endpoint("/api/pull"))
      .with(
        body: JSON.generate(
          "name" => "dummy",
          "insecure" => false,
          "stream" => false
        )
      ).to_return(
        body: JSON.generate(
          "status" => "success"
        )
      )

    response = @ollama.models.pull(name: "dummy", insecure: false)
    assert_equal response.result["status"], "success"
  end

  def test_models_pull_with_stream
    chunks = [
      { "status" => "pulling manifest" },
      { "status" => "verifying sha256 digest" },
      { "status" => "writing manifest" },
      { "status" => "removing any unused layers" },
      { "status" => "success" }
    ]
    stub_request(:post, endpoint("/api/pull"))
      .with(
        body: JSON.generate(
          "name" => "dummy",
          "insecure" => false,
          "stream" => true
        )
      ).to_return(
        body: chunks.map { |chunk| JSON.generate(chunk) }
      )

    result_chunks = []
    @ollama.models.pull(name: "dummy", insecure: false) do |chunk|
      result_chunks << chunk
    end

    chunks.each_with_index do |chunk, index|
      assert_equal result_chunks[index], chunk
    end
  end

  def test_models_push
    stub_request(:post, endpoint("/api/push"))
      .with(
        body: JSON.generate(
          "name" => "dummy",
          "insecure" => false,
          "stream" => false
        )
      ).to_return(
        body: ""
      )

    response = @ollama.models.push(name: "dummy", insecure: false)
    assert_equal response.ok?, true
  end

  def test_models_push_with_stream
    chunks = [
      { "status " => "retrieving manifest " },
      { "status " => "pushing manifest " },
      { "status " => "success " }
    ]
    stub_request(:post, endpoint("/api/push"))
      .with(
        body: JSON.generate(
          "name" => "dummy",
          "insecure" => false,
          "stream" => true
        )
      ).to_return(
        body: chunks.map { |chunk| JSON.generate(chunk) }
      )

    result_chunks = []
    @ollama.models.push(name: "dummy", insecure: false) do |chunk|
      result_chunks << chunk
    end

    chunks.each_with_index do |chunk, index|
      assert_equal result_chunks[index], chunk
    end
  end

  def test_models_create
    stub_request(:post, endpoint("/api/create"))
      .with(
        body: JSON.generate(
          "name" => "dummy",
          "modelfile" => "FROM @sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n",
          "stream" => false
        )
      ).to_return(body: JSON.generate("status" => "success"))

    response = @ollama.models.create(name: "dummy", modelfile: "FROM @sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n")
    assert_equal response.result["status"], "success"
  end

  def test_models_create_with_stream
    chunks = [
      { "status" => "creating model layer" },
      { "status" => "creating model layer" },
      { "status" => "creating template layer" },
      { "status" => "creating system layer" },
      { "status" => "creating parameters layer" },
      { "status" => "creating config layer" },
      { "status" => "using already created layer sha256:2af3b81862c6be03c769683af18efdadb2c33f60ff32ab6f83e42c043d6c7816" },
      { "status" => "using already created layer sha256:af0ddbdaaa26f30d54d727f9dd944b76bdb926fdaf9a58f63f78c532f57c191f" },
      { "status" => "using already created layer sha256:c8472cd9daed5e7c20aa53689e441e10620a002aacd58686aeac2cb188addb5c" },
      { "status" => "using already created layer sha256:7a069584bba7fc55cd963748a5047ce577faeefa9742f77941dfe47394a129f2" },
      { "status" => "using already created layer sha256:a22598645b99ea505e292a473290d1b8bd33a797aff3da8d8b788eb7b92c2910" },
      { "status" => "writing manifest" },
      { "status" => "success" }
    ]

    stub_request(:post, endpoint("/api/create"))
      .with(body: JSON.generate(
        "name" => "dummy",
        "modelfile" => "FROM @sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n",
        "stream" => true
      ))
      .to_return(body: chunks.map { |chunk| JSON.generate(chunk) })

    result_chunks = []
    @ollama.models.create(name: "dummy", modelfile: "FROM @sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n") do |chunk|
      result_chunks << chunk
    end

    chunks.each_with_index do |chunk, index|
      assert_equal result_chunks[index], chunk
    end
  end

  def test_generate_completion
    stub_request(:post, endpoint("/api/generate"))
      .with(body: JSON.generate(
        "model" => "dummy",
        "prompt" => "Why is the sky blue?",
        "images" => [],
        "stream" => false
      ))
      .to_return(body: JSON.generate(
        "model" => "dummy",
        "response" => "I don't know",
        "done" => true
      ))

    response = @ollama.completion.create(model: "dummy", prompt: "Why is the sky blue?")
    assert_equal response.result["model"], "dummy"
    assert_equal response.result["response"], "I don't know"
    assert_equal response.result["done"], true
  end

  def test_generate_completion_with_stream
    chunks = [
      { "model" => "dummy", "response" => "I ", "done" => false },
      { "model" => "dummy", "response" => "don't ", "done" => false },
      { "model" => "dummy", "response" => "know", "done" => true }
    ]

    stub_request(:post, endpoint("/api/generate"))
      .with(body: JSON.generate(
        "model" => "dummy",
        "prompt" => "Why is the sky blue?",
        "images" => [],
        "stream" => true
      ))
      .to_return(
        body: chunks.map { |chunk| JSON.generate(chunk) }
      )

    result_chunks = []
    @ollama.completion.create(model: "dummy", prompt: "Why is the sky blue?") do |chunk|
      result_chunks << chunk
    end

    chunks.each_with_index do |chunk, index|
      assert_equal result_chunks[index], chunk
    end
  end

  private
    def endpoint(path)
      URI.join(@base_url, path).to_s
    end
end
