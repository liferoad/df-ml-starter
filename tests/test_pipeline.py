# standard libraries
from pathlib import Path

# third party libraries
import apache_beam as beam

# dfml libraries
from src.config import ModelConfig, SinkConfig, SourceConfig
from src.pipeline import build_pipeline

DATA_FILE_PATH = Path(__file__).parent.parent / "data"


def test_build_pipeline():
    model_config = ModelConfig(
        model_state_dict_path="gs://apache-beam-ml/models/torchvision.models.resnet101.pth",
        model_class_name="resnet101",
        model_params={"num_classes": 1000},
    )
    source_config = SourceConfig(input=str(DATA_FILE_PATH / "openimage_10.txt"))
    sink_config = SinkConfig(output="beam-output/my_output.txt")

    p = beam.Pipeline()
    build_pipeline(p, source_config=source_config, sink_config=sink_config, model_config=model_config)
