# tfmesos

https://github.com/douban/tfmesos

1. login to tfmesos-framework machine
2.  ``cd tfmesos``
3. simple test
    ```
    sudo docker run -e MESOS_MASTER=mesos-master.mesos.private:5050 \
        -e DOCKER_IMAGE=tfmesos/tfmesos \
        --net=host \
        -v /home/admin/tfmesos/examples/plus.py:/tmp/plus.py \
        --rm \
        -it \
        tfmesos/tfmesos \
        python /tmp/plus.py mesos-master.mesos.private:5050
    ```
4. mnist test
    ```
    sudo docker run --rm -it -e MESOS_MASTER=mesos-master.mesos.private:5050 \
                 --net=host \
                 -v /home/admin/tfmesos/examples/mnist/:/tmp/mnist \
                 -v /etc/passwd:/etc/passwd:ro \
                 -v /etc/group:/etc/group:ro \
                 -u `id -u` \
                 -w /tmp/mnist \
                 tfmesos/tfmesos \
                 python mnist.py --worker-gpus 1
    ```

