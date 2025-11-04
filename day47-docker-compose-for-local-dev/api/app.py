from fastapi import FastAPI, HTTPException
import os, redis
app = FastAPI()
r = redis.Redis(host=os.getenv('REDIS_HOST','redis'), port=int(os.getenv('REDIS_PORT','6379')), db=int(os.getenv('REDIS_DB','0')), decode_responses=True)
@app.get('/health')
def health():
    try:
        r.ping(); return {'status':'ok','redis':'up'}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f'redis error: {e}')
@app.get('/')
def root(): return {'service':'compose-demo','version': os.getenv('APP_VERSION','0.0.1')}
@app.get('/cache')
def cache(key: str, value: str=None):
    if value is not None:
        r.set(key,value); return {'key':key,'value':value,'written':True}
    return {'key':key,'value': r.get(key)}
