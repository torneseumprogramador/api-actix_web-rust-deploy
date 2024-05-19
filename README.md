# Como fiz o deploy
- Instalar o docker
```shell
# instalando libs
sudo apt update
sudo apt upgrade
sudo apt install nginx
sudo apt install mysql-client

# instalando docker
sudo apt install docker.io
sudo usermod -aG docker ubuntu
sudo reboot # restarta usuario
docker ps

```

- Dump mysql
```mysql
-- MySQL dump 10.13  Distrib 5.7.44, for osx10.16 (x86_64)
--
-- Host: localhost    Database: desafio_rust_alunos_com_orm
-- ------------------------------------------------------
-- Server version       5.7.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alunos`
--

DROP TABLE IF EXISTS `alunos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alunos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) DEFAULT NULL,
  `matricula` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alunos`
--

LOCK TABLES `alunos` WRITE;
/*!40000 ALTER TABLE `alunos` DISABLE KEYS */;
INSERT INTO `alunos` VALUES (1,'Anderson Martins','AM33'),(2,'Belotec','BL667'),(5,'Danilo Santos','522DAN'),(7,'Eduardo','EDU55'),(9,'xxxxxxx','12jssss'),(10,'xxxxxxx','12jssss'),(11,'xxxxxxx','12jssss'),(12,'Reinaldo','RD64'),(16,'Breno','BR55'),(17,'Caue','CE44');
/*!40000 ALTER TABLE `alunos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alunos_notas`
--

DROP TABLE IF EXISTS `alunos_notas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alunos_notas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aluno_id` int(11) DEFAULT NULL,
  `nota` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alunos_notas`
--

LOCK TABLES `alunos_notas` WRITE;
/*!40000 ALTER TABLE `alunos_notas` DISABLE KEYS */;
INSERT INTO `alunos_notas` VALUES (16,7,7),(17,7,8),(18,7,5.5),(26,2,1),(27,2,3),(28,2,8),(29,2,5),(42,12,9),(43,12,10),(44,12,7),(45,12,9),(47,5,6.8),(48,5,9.9),(58,1,8),(59,1,9),(60,1,10),(67,16,10),(68,16,8),(69,16,9),(70,17,7.9),(71,17,5.9);
/*!40000 ALTER TABLE `alunos_notas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `senha` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (2,'Danilo','danilo@teste.com','$2b$12$ADkAssT28FpqjwxROd43rewDzw42rv/z1lp/qYeNB2U9bg1XHZ6Pi');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-18  6:30:35
```

```shell
# cria arquivo dump
vim dump.sql # cola o dado do dump

# Restaurar dump
mysql -uSEU_USUARIO -p'SUA_SENHA' -h SEU_HOST_RDS desafio_rust_alunos_com_orm < dump.sql 

```
- Config nginx
```nginx
server {
    listen 80;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```shell
sudo vim /etc/nginx/sites-available/default # colocar a configuração
sudo systemctl restart nginx
```

- Rodar docker
```shell

# clone app
git clone https://github.com/torneseumprogramador/api-actix_web-rust-deploy.git
cd api-actix_web-rust-deploy/

# gerar imagem docker
docker build -t console-app .

docker run -d -p 8080:8080 --name console-app -e DATABASE_USER=SEU_USER -e DATABASE_PASSWORD=SEU_PASS -e DATABASE_DB=desafio_rust_alunos_com_orm -e DATABASE_HOST=SEU_HOST_RDS console-app
```

# OBS: não esqueça de librar a porta 80 no security group AWS