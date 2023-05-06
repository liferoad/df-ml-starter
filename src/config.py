# standard libraries
from enum import Enum

# third party libraries
from pydantic import BaseModel, Field


class ModelName(str, Enum):
    RESNET101 = "resnet101"
    MOBILENET_V2 = "mobilenet_v2"


class ModelConfig(BaseModel):
    model_state_dict_path: str = Field(..., description="path that contains the torch model state directory")
    model_class_name: ModelName = Field(..., description="Reference to the class definition of the model.")
    model_params: dict = Field(
        ...,
        description="Parameters passed to the constructor of the model_class. "
        "These will be used to instantiate the model object in the RunInference API.",
    )
    device: str = Field("CPU", description="Device to be used on the Runner. Choices are (CPU, GPU)")
    min_batch_size: int = 10
    max_batch_size: int = 100


class SourceConfig(BaseModel):
    input: str = Field(..., description="the input path to a text file")
    images_dir: str = Field(
        None,
        description="Path to the directory where images are stored."
        "Not required if image names in the input file have absolute path.",
    )


class SinkConfig(BaseModel):
    output: str = Field(..., description="the output path to save results as a text file")
