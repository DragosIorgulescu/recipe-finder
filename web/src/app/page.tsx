"use client"

import React, {useCallback, useEffect, useState} from "react"
import {X, Clock, Search} from "lucide-react"
import {Input} from "@/components/ui/input"
import {Button} from "@/components/ui/button"
import {Card, CardContent, CardFooter, CardHeader, CardTitle} from "@/components/ui/card"
import {Badge} from "@/components/ui/badge"
import { Switch } from "@/components/ui/switch"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import {QueryClient, QueryClientProvider, useQuery} from "@tanstack/react-query";
import {CreateMLCEngine, InitProgressReport} from "@mlc-ai/web-llm";
import {MLCEngine} from "@mlc-ai/web-llm/lib/engine";
import {ChatCompletionMessageParam} from "@mlc-ai/web-llm/lib/openai_api_protocols/chat_completion";

interface Recipe {
  id: number
  title: string
  cook_time: number
  prep_time: number
  rating: number
  cuisine: string
  category: string
  author: string
  image: string
  ingredients: { name: string }[]
}

function RecipeFinder() {
  const {isPending, error, data: recipes, isFetching, refetch} = useQuery<Recipe[]>({
    enabled: false, queryKey: ['recipes'], queryFn: async () => {
      const queryParams = new URLSearchParams({
        ingredients: tags.join(','),
      });

      const url = new URL('http://localhost:3000/api/v1/recipes')
      url.search = queryParams.toString()

      const response = await fetch(url)
      return await response.json()
    }
  })

  const [isLLMMode, setIsLLMMode] = useState(false)
  const [tags, setTags] = useState<string[]>([])
  const [inputValue, setInputValue] = useState("")
  const [LLMEngine, setLLMEngine] = useState<MLCEngine>()
  const [LLMProgress, setLLMProgress] = useState<InitProgressReport>()

  const initProgressCallback = (initProgress: InitProgressReport) => {
    console.log(initProgress);
    setLLMProgress(initProgress)
  }
  const selectedModel = "Llama-3.1-8B-Instruct-q4f32_1-MLC";

  const loadEngine = useCallback(async () => {
    const engine = await CreateMLCEngine(
      selectedModel,
      { initProgressCallback: initProgressCallback }, // engineConfig
    );

    setLLMEngine(engine)
  }, [])

  const queryEngine = useCallback(async (content: string) => {
    if (LLMEngine) {
      const messages: ChatCompletionMessageParam[] = [
        { role: "system", content: "You are a helpful AI chef whose role is to extract ingredients from the user message and return them in one line, separated by commas. The outpus should not include any other symbols" },
      ]

      const reply = await LLMEngine.chat.completions.create({
        messages: [ ...messages,
          { role: "user", content },
        ],
      });

      console.log(reply.choices[0].message);
      console.log(reply.usage);

      setTags(reply.choices[0].message?.content?.split(',') || [])
    }
  }, [LLMEngine])

  useEffect(() => {
    if (isLLMMode && !LLMEngine) {
      loadEngine()
    }
  }, [isLLMMode, LLMEngine, loadEngine])

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setInputValue(e.target.value)
  }

  const handleLLMInputBlur = async (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    queryEngine(e.target.value)
  }


  const handleInputKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && inputValue) {
      e.preventDefault()
      addTag(inputValue)
    }
  }

  const addTag = (tag: string) => {
    if (tag && !tags.includes(tag)) {
      setTags([...tags, tag])
      setInputValue("")
    }
  }

  const removeTag = (tagToRemove: string) => {
    setTags(tags.filter(tag => tag !== tagToRemove))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    await refetch()
  }

  return (
    <div className="max-w-6xl mx-auto p-4">
      <h1 className="text-3xl font-bold mb-6">Recipe Finder</h1>
      <span><i>!! Switching to LLM mode will download and cache a Llama-3.1-8B (4GB) model which will run locally in the browser, please make sure you have the available disk space before switching !!</i></span>

      {isLLMMode && LLMProgress && (
        <>
          <br/>
          <span>LLM Status: <b>{LLMProgress.text}</b></span>
        </>
      )}
      <div className="flex items-center justify-end space-x-2 mb-4">
        <Label htmlFor="input-mode">LLM Mode</Label>
        <Switch
          id="input-mode"
          checked={isLLMMode}
          onCheckedChange={setIsLLMMode}
        />
      </div>
      <form onSubmit={handleSubmit} className="space-y-4 mb-8">
        {isLLMMode && (
          <div>
            <Textarea
              value={inputValue}
              onChange={handleInputChange}
              onBlur={handleLLMInputBlur}
              className="min-h-[100px]"
              placeholder="Describe the ingredients you're have available..."
              aria-label="Describe your ingredients"
              disabled={!LLMEngine}
            />


            <div className="flex flex-wrap items-center p-2">
              {tags.map(tag => (
                <span
                  key={tag}
                  className="flex items-center m-1 px-2 py-1 bg-primary text-primary-foreground rounded-sm text-sm"
                >
                  {tag}
                  <button
                    type="button"
                    onClick={() => removeTag(tag)}
                    className="ml-1 focus:outline-none"
                    aria-label={`Remove ${tag}`}
                  >
                    <X size={14}/>
                  </button>
                </span>
              ))}
            </div>
          </div>
        )}

        {!isLLMMode && (
          <div className="flex flex-wrap items-center p-2 border rounded-lg bg-background">
            {tags.map(tag => (
              <span
                key={tag}
                className="flex items-center m-1 px-2 py-1 bg-primary text-primary-foreground rounded-full text-sm"
              >
                {tag}
                <button
                  type="button"
                  onClick={() => removeTag(tag)}
                  className="ml-1 focus:outline-none"
                  aria-label={`Remove ${tag}`}
                >
                  <X size={14}/>
                </button>
              </span>
            ))}
            <Input
              type="text"
              value={inputValue}
              onChange={handleInputChange}
              onKeyDown={handleInputKeyDown}
              className="flex-grow border-none shadow-none focus-visible:ring-0 focus-visible:ring-offset-0"
              placeholder="Enter ingredients (press Enter to add)"
              aria-label="Enter ingredients"
            />
          </div>
        )}
        <Button type="submit" className="w-full text-lg py-6" size="lg" disabled={tags.length === 0 || isFetching}>
          {isFetching ? (
            <>
              <span className="loading loading-spinner loading-sm mr-2"></span>
              Searching...
            </>
          ) : (
            <>
              <Search className="mr-2 h-5 w-5"/> Find Recipes
            </>
          )}
        </Button>
      </form>

      {error && (
        <div className="col-span-full text-center py-10">
          <h2 className="text-2xl font-semibold mb-2">Oops! Something went terribly wrong</h2>
          <p className="text-muted-foreground">
            Try again?
          </p>
        </div>
      )}

      {!error && !isPending && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {recipes?.length > 0 ? (
            recipes.map((recipe) => (
              <RecipeCard key={recipe.id} recipe={recipe}/>
            ))
          ) : (
            <div className="col-span-full text-center py-10">
              <h2 className="text-2xl font-semibold mb-2">No recipes found</h2>
              <p className="text-muted-foreground">
                Try adding different ingredients or removing some tags to broaden your search.
              </p>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

function RecipeCard({recipe}: { recipe: Recipe }) {
  return (
    <Card className="overflow-hidden">
      <img src={recipe.image} alt={recipe.title} className="w-full h-48 object-cover"/>
      <CardHeader>
        <CardTitle>{recipe.title}</CardTitle>
        <div className="flex items-center space-x-2 text-sm text-muted-foreground">
          <span>{recipe.author}</span>
          {recipe.cuisine && (
            <>
              <span>•</span>
              <span>{recipe.cuisine}</span>
            </>
          )}
        </div>
      </CardHeader>
      <CardContent>
        <div className="flex items-center space-x-2 mb-2">
          <Clock size={16}/>
          <span className="text-sm text-muted-foreground">
            Prep: {recipe.prep_time} min | Cook: {recipe.cook_time} min
          </span>
        </div>
        <div className="flex items-center space-x-2 mb-4">
          <span className="text-sm font-semibold">Rating: {recipe.rating.toFixed(1)}</span>
          <Badge variant="secondary">{recipe.category}</Badge>
        </div>
        <div>
          <h3 className="font-semibold mb-1">Ingredients:</h3>
          <ul className="list-disc list-inside text-sm">
            {recipe.ingredients.map(({name}) => (
              <li key={name}>{name}</li>
            ))}
          </ul>
        </div>
      </CardContent>
      <CardFooter>
        <Button variant="outline" className="w-full">View Recipe</Button>
      </CardFooter>
    </Card>
  )
}

const queryClient = new QueryClient()

export default function Home() {
  return (
    <QueryClientProvider client={queryClient}>
      <RecipeFinder/>
    </QueryClientProvider>
  )
}
