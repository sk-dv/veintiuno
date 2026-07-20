mongoose = require 'mongoose'
{ MongoMemoryServer } = require 'mongodb-memory-server'

# Levanta una instancia de MongoDB EN MEMORIA (sin instalar Mongo).
# Ideal para desarrollo local: cero configuracion y arranca con un comando.
# Nota: los datos NO persisten al reiniciar el servidor. Para persistencia
# real (produccion) se migrara a MongoDB Atlas segun el plan de desarrollo.
start = ->
  mongod = await MongoMemoryServer.create()
  uri = mongod.getUri()
  await mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true, useFindAndModify: false, useCreateIndex: false })
  console.log "MongoDB en memoria conectada:", uri

start().catch (err) -> console.error "Error iniciando Mongo en memoria:", err

module.exports = mongoose
