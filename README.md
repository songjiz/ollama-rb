# Ollama Ruby Library

The Ollama Ruby library provides the easiest way to integrate your Ruby project with [Ollama](https://github.com/jmorganca/ollama).

## Index

- [Ollama Ruby Library](#ollama-ruby-library)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Create a Client](#create-a-client)
    - [Generate a chat completion](#generate-a-chat-completion)
    - [Generate a completion](#generate-a-completion)
    - [Create a Model](#create-a-model)
    - [List Local Models](#list-local-models)
    - [Show Model Information](#show-model-information)
    - [Copy a Model](#copy-a-model)
    - [Delete a Model](#delete-a-model)
    - [Pull a Model](#pull-a-model)
    - [Push a Model](#push-a-model)
    - [Generate Embeddings](#generate-embeddings)
  - [Development](#development)
  - [Contributing](#contributing)
  - [License](#license)

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add ollama-rb
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install ollama-rb
```

## Usage

### Create a Client

```ruby
require "ollama"

ollama = Ollama::Client.new

# Specify url, default to http://localhost:11434
ollama = Ollama::Client.new(base_url: "http://localhost:11434")
```

### Generate a chat completion

```ruby
response = ollama.chat.create(
  model: "llama2",
  messages: [
    { role: "user", content: "Why is the sky blue?" }
  ]
)
# => #<Ollama::Response:0x000000011fa1a840...
response.ok?
# => true
response.result
# =>
# {"model"=>"llama2",
#  "created_at"=>"2024-03-20T06:53:18.298807078Z",
#  "message"=>
#   {"role"=>"assistant",
#    "content"=> ...
```

**Streaming response**

```ruby
response = ollama.chat.create(
  model: "llama2",
  messages: [
    { role: "user", content: "Why is the sky blue?" }
  ]
) do |chunk|
  puts chunk
end
# =>
#{"model"=>"llama2", "created_at"=>"2024-03-20T06:57:57.513159464Z", "message"=>{"role"=>"assistant", "content"=>"\n"}, "done"=>false}
#{"model"=>"llama2", "created_at"=>"2024-03-20T06:57:57.616592691Z", "message"=>{"role"=>"assistant", "content"=>"The"}, "done"=>false}
#{"model"=>"llama2", "created_at"=>"2024-03-20T06:57:57.70737176Z", "message"=>{"role"=>"assistant", "content"=>" sky"}, "done"=>false}
#{"model"=>"llama2", "created_at"=>"2024-03-20T06:57:57.796324471Z", "message"=>{"role"=>"assistant", "content"=>" appears"}, "done"=>false}
#{"model"=>"llama2", "created_at"=>"2024-03-20T06:57:57.884097322Z", "message"=>{"role"=>"assistant", "content"=>" blue"}, "done"=>false}
# ...
```

### Generate a completion

```ruby
response = ollama.completion.create(model: "llama2", prompt: "hello!")

response.result
# =>
# {"model"=>"llama2",
#  "created_at"=>"2024-03-20T08:03:27.910169204Z",
#  "response"=>"Hello there! It's nice to meet you. Is there something I can help you with or would you like to chat?",
#  "done"=>true,
#  "context"=>
#   [518,
#    25580,
#    29962,
#    3532,
#    ...
#    13563,
#    29973],
#  "total_duration"=>6212545461,
#  "load_duration"=>2024921059,
#  "prompt_eval_count"=>22,
#  "prompt_eval_duration"=>1815255000,
#  "eval_count"=>27,
#  "eval_duration"=>2371725000}
```

**Streaming response**

```ruby
ollama.completion.create(model: "llama2", prompt: "hello!") do |chunk|
  puts chunk
end
# =>
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.196291424Z", "response"=>"Hello", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.285639365Z", "response"=>"!", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.3753276Z", "response"=>" It", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.464252328Z", "response"=>"'", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.552918803Z", "response"=>"s", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.641877239Z", "response"=>" nice", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.730397754Z", "response"=>" to", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.819209813Z", "response"=>" meet", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.907875913Z", "response"=>" you", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:01.996684973Z", "response"=>".", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.085516116Z", "response"=>" Is", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.1781973Z", "response"=>" there", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.267609408Z", "response"=>" something", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.357217892Z", "response"=>" I", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.446981087Z", "response"=>" can", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.536783282Z", "response"=>" help", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.645166548Z", "response"=>" you", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.737494769Z", "response"=>" with", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.82763751Z", "response"=>" or", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:02.917220827Z", "response"=>" would", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:03.006731978Z", "response"=>" you", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:03.098463277Z", "response"=>" like", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:03.18839214Z", "response"=>" to", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:03.277780622Z", "response"=>" chat", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:03.367252189Z", "response"=>"?", "done"=>false}
# {"model"=>"llama2", "created_at"=>"2024-03-20T08:08:03.457281303Z", "response"=>"", "done"=>true, "context"=>[518, 25580, 29962, 3532, 14816, 29903, 29958, 5299, 829, 14816, 29903, 6778, 13, 13, 12199, 29991, 518, 29914, 25580, 29962, 13, 10994, 29991, 739, 29915, 29879, 7575, 304, 5870, 366, 29889, 1317, 727, 1554, 306, 508, 1371, 366, 411, 470, 723, 366, 763, 304, 13563, 29973], "total_duration"=>2432818562, "load_duration"=>1470557, "prompt_eval_duration"=>167895000, "eval_count"=>26, "eval_duration"=>2260824000}
```

### Create a Model

```ruby
ollama.models.create(name: "mario", modelfile: "FROM llama2\nSYSTEM You are mario from Super Mario Bros.") do |chunk|
  puts chunk
end
# =>
# {"status"=>"reading model metadata"}
# {"status"=>"creating system layer"}
# {"status"=>"using already created layer sha256:8934d96d3f08982e95922b2b7a2c626a1fe873d7c3b06e8e56d7bc0a1fef9246"}
# {"status"=>"using already created layer sha256:8c17c2ebb0ea011be9981cc3922db8ca8fa61e828c5d3f44cb6ae342bf80460b"}
# {"status"=>"using already created layer sha256:7c23fb36d80141c4ab8cdbb61ee4790102ebd2bf7aeff414453177d4f2110e5d"}
# {"status"=>"using already created layer sha256:2e0493f67d0c8c9c68a8aeacdf6a38a2151cb3c4c1d42accf296e19810527988"}
# {"status"=>"using already created layer sha256:fa304d6750612c207b8705aca35391761f29492534e90b30575e4980d6ca82f6"}
# {"status"=>"writing layer sha256:1741cf59ce26ff01ac614d31efc700e21e44dd96aed60a7c91ab3f47e440ef94"}
# {"status"=>"writing layer sha256:786d77d232711e91aafad74df1bacc01e630525d8e83d57a758693725f08d511"}
# {"status"=>"writing manifest"}
# {"status"=>"success"}
```

### List Local Models

```ruby
response = ollama.models.list
response.result
# =>
# {"models"=>
#   [{"name"=>"llama2:latest",
#     "model"=>"llama2:latest",
#     "modified_at"=>"2024-03-19T10:37:39.212281917Z",
#     "size"=>3826793677,
#     "digest"=>"78e26419b4469263f75331927a00a0284ef6544c1975b826b15abdaef17bb962",
#     "details"=>{"parent_model"=>"", "format"=>"gguf", "family"=>"llama", "families"=>["llama"], "parameter_size"=>"7B", "quantization_level"=>"Q4_0"}},
#    {"name"=>"mario:latest",
#     "model"=>"mario:latest",
#     "modified_at"=>"2024-03-20T08:21:20.316403821Z",
#     "size"=>3826793787,
#     "digest"=>"291f46d2fa687dfaff45de96a8cb6e32707bc16ec1e1dfe8d65e9634c34c660c",
#     "details"=>{"parent_model"=>"", "format"=>"gguf", "family"=>"llama", "families"=>["llama"], "parameter_size"=>"7B", "quantization_level"=>"Q4_0"}}]}
```

### Show Model Information

```ruby
response = ollama.models.show("mario")
response.result
=>
{"license"=>
  "LLAMA 2 COMMUNITY LICENSE AGREEMENT\t\nLlama 2 Version Release Date: July 18, 2023\n\n\"Agreement\" means the terms and conditions for use, reproduction, distribution and \nmodification of the Llama Materials set forth herein.\n\n\"...",
  "modelfile"=>
  "# Modelfile generated by \"ollama show\"\n# To build a new Modelfile based on this one, replace the FROM line with:\n# FROM mario:latest\n\nFROM llama2:latest\nTEMPLATE \
"\"\"[INST] <<SYS>>{{ .System }}<</SYS>>\n\n{{ .Prompt }} [/INST]\n\"\"\"\nSYSTEM \"\"\"You are mario from Super Mario Bros.\"\"\"\nPARAMETER stop \"[INST]\"\nPARAMETER stop
 \"[/INST]\"\nPARAMETER stop \"<<SYS>>\"\nPARAMETER stop \"<</SYS>>\"",
 "parameters"=>
  "stop                           \"[INST]\"\nstop                           \"[/INST]\"\nstop                           \"<<SYS>>\"\nstop                           \"<</SYS
>>\"",
 "template"=>"[INST] <<SYS>>{{ .System }}<</SYS>>\n\n{{ .Prompt }} [/INST]\n",
 "system"=>"You are mario from Super Mario Bros.",
 "details"=>{"parent_model"=>"llama2:latest", "format"=>"gguf", "family"=>"llama", "families"=>["llama"], "parameter_size"=>"7B", "quantization_level"=>"Q4_0"}}
```

### Copy a Model

```ruby
response = ollama.models.copy(source: "llama2")
# Same as
response = ollama.models.copy(source: "llama2", destination: "llama2-backup")
response.ok?
# => true

response = ollama.models.copy(source: "non-existence")
response.ok?
# => false
response.result
# => {"error"=>"model 'non-existence' not found"}
```

### Delete a Model

```ruby
response = ollama.models.delete("llama2-backup")
response.ok?
# => true

response = ollama.models.delete("non-existence")
response.ok?
# => false
response.result
# => {"error"=>"model 'non-existence' not found"}
```

### Pull a Model

```ruby
ollama.models.pull(name: "tinyllama") do |chunk|
  puts chunk
end
# =>
# {"status"=>"pulling manifest"}
# {"status"=>"pulling 2af3b81862c6", "digest"=>"sha256:2af3b81862c6be03c769683af18efdadb2c33f60ff32ab6f83e42c043d6c7816", "total"=>637699456, "completed"=>637699456}
# {"status"=>"pulling af0ddbdaaa26", "digest"=>"sha256:af0ddbdaaa26f30d54d727f9dd944b76bdb926fdaf9a58f63f78c532f57c191f", "total"=>70, "completed"=>70}
# {"status"=>"pulling c8472cd9daed", "digest"=>"sha256:c8472cd9daed5e7c20aa53689e441e10620a002aacd58686aeac2cb188addb5c", "total"=>31, "completed"=>31}
# {"status"=>"pulling fa956ab37b8c", "digest"=>"sha256:fa956ab37b8c21152f975a7fcdd095c4fee8754674b21d9b44d710435697a00d", "total"=>98, "completed"=>98}
# {"status"=>"pulling 6331358be52a", "digest"=>"sha256:6331358be52a6ebc2fd0755a51ad1175734fd17a628ab5ea6897109396245362", "total"=>483, "completed"=>483}
# {"status"=>"verifying sha256 digest"}
# {"status"=>"writing manifest"}
# {"status"=>"removing any unused layers"}
# {"status"=>"success"}
```

### Push a Model

You need to create an account at https://ollama.ai and add your Public Key at https://ollama.ai/settings/keys to allow you push models to your namespace.

```ruby
ollama.models.copy(source: "mario", destination: "your-namespace/mario")
ollama.models.push(name: "your-namespace/mario") do |chunk|
  puts chunk
end
```

### Generate Embeddings

```ruby
response = ollama.embeddings.create(model: "llama2", prompt: "Hello!")
response.result
# =>
{"embedding"=>
  [1.3464512825012207,
   -1.0983257293701172,
   ...
   -2.2046988010406494, 0.3163630962371826] }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/songjiz/ollama-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
