# server/models.py

from pydantic import BaseModel, Field
from typing import Optional, List

class ProductCreate(BaseModel):
    name: str
    price: float
    image: str
    organic: bool
    category: str

class Product(BaseModel):
    id: Optional[int] = Field(default=None)
    name: str
    price: float
    image: str
    organic: bool
    category: str

class CartItem(BaseModel):
    product_id: int
    quantity: int

class FavoriteItem(BaseModel):
    product_id: int

# Новые модели для ответов
class CartItemResponse(BaseModel):
    product: Product
    quantity: int

class FavoriteItemResponse(BaseModel):
    product: Product
