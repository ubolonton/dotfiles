{:user {:plugins [[lein-midje "3.2.1"]]

        :dependencies
        [[com.cemerick/pomegranate "0.4.0"]]

        :injections
        [(defn add-dependency
           "Adds new dependency without reloading the JVM."
           [dep-vec]
           (require 'cemerick.pomegranate)
           ((resolve 'cemerick.pomegranate/add-dependencies)
            :coordinates [dep-vec]
            :repositories (merge @(resolve 'cemerick.pomegranate.aether/maven-central)
                                 {"clojars" "https://clojars.org/repo"})))]}}
