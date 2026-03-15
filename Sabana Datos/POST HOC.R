
library(tidyverse)
library(readxl)
library(lme4)
library(readxl)
library(car)
library(ggeffects)
library(emmeans)
library(performance)





glm <- read.csv("datos_long_glmm.csv", header = T)


glm_filtred <- glm[glm$zeros_OTHER <= 25, ] 
glm_filtred <- glm_filtred[glm_filtred$zeros_SELF <=25, ]
glm_filtred <- subset(glm_filtred, decision!= 2)


#Change the tipe of the variable

str(glm)

alldata <- data.frame(as.factor(glm_filtred$sub),
                      as.factor(glm_filtred$decision),
                      as.factor(glm_filtred$grupo),
                      as.factor(glm_filtred$agent),
                      as.factor(glm_filtred$AIM_2),
                      as.numeric(as.character(glm_filtred$success)),
                      as.numeric(as.character(glm_filtred$tasa_fallo_other)),
                      as.numeric(as.character(glm_filtred$tasa_fallo_self)),
                      as.numeric(as.character(glm_filtred$zeros_OTHER)),
                      as.numeric(as.character(glm_filtred$zeros_SELF)),
                      as.numeric(as.character(glm_filtred$reward)),
                      as.numeric(as.character(glm_filtred$effort)),
                      as.numeric(as.character(glm_filtred$trail)),
                      as.numeric(as.character(glm_filtred$AIM_num)),
                      as.numeric(as.character(glm_filtred$AIM_3)),
                      as.numeric(as.character(glm_filtred$AIM_4))
)

colnames(alldata)<-c("sub", "decision", "grupo", "agent", "AIM_2", "success", "c.tasa_fallo_other", 
                     "c.tasa_fallo_self", "c.zeros_other", "c.zeros_self", "c.reward", "c.effort", "c.trail",
                     "c.AIM_num", "c.AIM_3", "c.AIM_4")


numcols <- grep("^c\\.",names(alldata))
alldata.sc <- alldata
alldata.sc[,numcols] <- scale(alldata.sc[,numcols])


### GLMM decision ####


# Este modelo observa todas la interacciones, con ramdon effect
modelo_1a <-glmer(decision ~ c.reward*agent*c.effort*grupo + (1 + c.effort + c.reward|sub)
                  ,data=alldata.sc,
                  family=binomial,
                  control = glmerControl(optimizer = "bobyqa",
                                         optCtrl=list(maxfun=2e5)))
                         #Los resultados de este modelo entregan un efecto significativo en 
                         #reward, agent, effort*agent*grupo
    

# Este modelo observa todas la interacciones, sin ramdon effect
modelo_1a_sim <- glmer(decision ~ c.reward*agent*c.effort*grupo + (1|sub)
                       ,data = alldata.sc,
                       family = binomial,
                       control = glmerControl(optimizer = "bobyqa",
                                              optCtrl = list(maxfun=2e5)))
                        #Los resultados de este modelo entregan un efecto significativo en 
                  #reward, agent, effort, grupo, agent*grupo, agent*effort*grupo



#  Este modelo separa las interacciones por reward y effort 
modelo_4.1 <-glmer(decision ~ c.reward*agent*grupo + c.effort*agent*grupo + (1 + c.effort + c.reward|sub)
                            ,data=alldata.sc,
                            family=binomial,
                            control = glmerControl(optimizer = "bobyqa",
                                                   optCtrl=list(maxfun=2e5)))


modelo_4.1_agent <-glmer(decision ~ c.reward*agent*grupo + c.effort*agent*grupo + (1 + c.effort + c.reward + agent|sub)
                   ,data=alldata.sc,
                   family=binomial,
                   control = glmerControl(optimizer = "bobyqa",
                                          optCtrl=list(maxfun=2e5)))


                       #Los resultados de este mdelo entregan un efecto significativo en 
                  #reward, agent, grupo y agent*grupo*effort

           
#   Este modelo separa las interacciones por reward y effort, es sin efectos ramdons
modelo_4.1.simp <-glmer(decision ~ c.reward*agent*grupo + c.effort*agent*grupo + (1|sub)
                                  ,data=alldata.sc,
                                  family=binomial,
                                  control = glmerControl(optimizer = "bobyqa",
                                                         optCtrl=list(maxfun=2e5)))
                      #Los resultados de este modelo entregan un efecto significativo en 
                 #reward, agent, grupo, effort, reward*agent, agent*grupo, agent*grupo*effort



#  Este modelo separa las interacciones por reward y effort, se quita la variable grupo y es sin efectos ramdon
modelo_4.1.simp_g <-glmer(decision ~ c.reward*agent + c.effort*agent + (1|sub)
                          ,data=alldata.sc,
                          family=binomial,
                          control = glmerControl(optimizer = "bobyqa",
                                                 optCtrl=list(maxfun=2e5)))
             #Los restultados de este modelo entregan un efecto significativo en 
       #reward, agent, effort y reward*agent



plot(ggpredict(modelo_4.1.simp_g, terms = c("c.reward", "agent"))) +
  ggtitle("Modelo 4.1 simplificado SIN grupo Effort × Agent") +
  ylab("Probabilidad predicha de decisión") +
  xlab("Nivel de esfuerzo (c.effort)") +
  theme_minimal()


modelo_comp_grupo_84 <- anova(modelo_1a, modelo_4.1, modelo_4.1.simp, modelo_1a_sim, modelo_4.1.simp_g)
               #Al comparar los modelos, gana el modelo_4.1 

### GLMM success ####

alldata.sc_a <- subset(alldata.sc, decision!= 0)


#Este modelo observa las interacciones en su conjunto,
modelo_succes_1 <-glmer(success ~ c.reward*agent*grupo + agent*c.effort*grupo + (1 + c.effort + c.reward|sub)
                        ,data=alldata.sc_a,
                        family=binomial,
                        control = glmerControl(optimizer = "bobyqa",
                                               optCtrl=list(maxfun=2e5)))
              #Los resultados de este modelo entregan efecto en agente y effort



#En este modelo se separan las interacciones por reward y effort, además de que no se tienen efectos ramdon
modelo_succes_1.1 <-glmer(success ~ c.reward*agent*grupo + agent*c.effort*grupo + (1|sub)
                         ,data=alldata.sc_a,
                         family=binomial,
                         control = glmerControl(optimizer = "bobyqa",
                                                optCtrl=list(maxfun=2e5)))
              #Los resultados de este entregan un efecto en agente, effort, agente*grupo



#En este modelo se separan las interacciones por reward y effort, además de que no se tienen efectos ramdon
modelo_succes_2 <-glmer(success ~ c.reward*agent*c.effort*grupo + (1 + c.reward + c.effort|sub)
                        ,data=alldata.sc_a,
                        family=binomial,
                        control = glmerControl(optimizer = "bobyqa",
                                               optCtrl=list(maxfun=2e5)))
            #Los resultados de este modelo entregan un efecto en agente, effort, reward*effort, agente*grupo


#Este modelo observa las interacciones en su conjunto, no presenta efectos ramdon
modelo_succes_2.1 <-glmer(success ~ c.reward*agent*c.effort*grupo + (1|sub)
                        ,data=alldata.sc_a,
                        family=binomial,
                        control = glmerControl(optimizer = "bobyqa",
                                               optCtrl=list(maxfun=2e5)))
                  #Los resultados del modelo entrega interacciones en effort, grupo, agent*grupo
                  #reward*effort*grupo


#Grafico de los modelos success 
ggpredict(modelo_succes_2.1, c("grupo","agent")) %>% plot()


model_comp_success <- anova(modelo_succes_1, modelo_succes_1.1, modelo_succes_2, modelo_succes_2.1)
                      #Al comparar los modelos, gana el modelo_succes_1

### Post Hoc ####


#Se crea una lista con los valores de effort
niveles_esfuerzo <- list(c.effort = c(-1.3412537, -0.4459018
                                      , 0.4494501, 1.3448020))

# Calculamos las medias marginales
em_posthoc_4.1 <- emmeans(modelo_4.1, 
                          ~  grupo*agent | c.effort, 
                          at = niveles_esfuerzo,
                          type = "response") #este formato compara por niveles de esfuerzo 

pairs(em_posthoc_4.1)


#Segundo forma de realizar el post hoc comparando pendientes 
slopes_effort_4.1 <- emtrends(modelo_4.1,
                              ~  agent * grupo,
                              var = "c.effort")#este formato compara por pendiente 
pairs(slopes_effort_4.1)



#post  hoc modelo succes 
em_posthoc_e_2.1 <- emmeans(modelo_succes_2.1, 
                        ~ grupo * agent,
                        type = "response")

pairs(em_posthoc_e_2.1)


slopes_success_2.1 <- emtrends(modelo_succes_2.1,
                             ~ grupo*agent,
                             var = "c.reward")
pairs(slopes_success_2.1)
df_success_2.1 <- as.data.frame(em_posthoc_e_2.1)




#graficos success POST HOC 
ggplot(df_success_2.1, aes(x = agent, y = prob, color = grupo)) +
  geom_point(
    position = position_dodge(width = 0.3),
    size = 3
  ) +
  geom_errorbar(
    aes(ymin = asymp.LCL, ymax = asymp.UCL),
    width = 0.15,
    position = position_dodge(width = 0.3)
  ) +
  labs(
    x = "Agente",
    y = "Probabilidad predicha de fallo",
    color = "Grupo"
  ) +
  theme_light(base_size = 14)
      #Este g



#graficos DECISION
df_medias_4.1 <- as.data.frame(em_posthoc_4.1)

ggplot(df_medias_4.1, aes(x = agent, y = prob, color = grupo, group = grupo)) +
  facet_grid(~ c.effort, labeller = label_both) + 
  geom_point(position = position_dodge(width = 0.3), size = 3) +
  geom_line(position = position_dodge(width = 0.3), linewidth = 1) +
  geom_errorbar(aes(ymin = asymp.LCL, ymax = asymp.UCL), 
                width = 0.2, 
                position = position_dodge(width = 0.3)) +
  labs(title = "Probabilidad de Decisión por Grupo, Agente y Esfuerzo - modelo 1a simp",
       y = "Probabilidad Predicha",
       x = "Tipo de Agente",
       color = "Grupo") +
  theme_bw() +
  theme(legend.position = "bottom")


 

ggplot(
  df_medias_4.1,
  aes(
    x = c.effort,
    y = prob,
    group = interaction(grupo, agent),
    color = grupo,
    linetype = agent
  )
) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_errorbar(
    aes(ymin = asymp.LCL, ymax = asymp.UCL),
    width = 0.05
  ) +
  scale_color_manual(
    values = c(
      "0" = "#1F77B4",  
      "1" = "#A52A2A"   
    ),
    name = "Grupo"
  ) +
  scale_linetype_manual(
    values = c(
      "1" = "solid",     # agente 0
      "0" = "dashed"    # agente 1 (escarchada)
    ),
    name = "Agente"
  ) +
  labs(
    x = "Nivel de esfuerzo",
    y = "Probabilidad predicha de decisión",
    color = "Agente",
    linetype = "Grupo"
  ) +
  theme_light(base_size = 14)

str(df_medias_4.1)


# Comparación de niveles de Esfuerzo por Agente
# Objetivo: Ver diferencias entre niveles de esfuerzo DENTRO de cada agente.
effortygrupo_contrast <- emmeans(modelo_4.1, 
                           pairwise ~ c.effort | agent*grupo, 
                           at = niveles_esfuerzo, 
                           type = "response", # Para obtener probabilidades en el output
                           pbkrtest.limit = 5012, lmerTest.limit = 5021) 

# Contraste de Interacción de Tendencias 
# Evaluar si la FORMA (tendencia lineal/cuadrática) de la curva de esfuerzo
# es diferente entre Self y Other.
concon <- contrast(effortygrupo_contrast[[1]], 
                   interaction = c("poly", "consec"), 
                   by = NULL) 

# Comparación de Agentes por nivel de Esfuerzo 
# Ver si hay diferencias significativas entre Self vs Other en cada punto de esfuerzo específico.
agent_contrast_effort <- emmeans(modelo_4.1, 
                                 pairwise ~ agent | c.effort, 
                                 at = niveles_esfuerzo, 
                                 type = "response",
                                 pbkrtest.limit = 5012, lmerTest.limit = 5021)

# Comparación de Grupos por Agente
# Ver si el Grupo Control difiere del Vulnerable mirando a cada agente por separado
# (Promediando a través de los niveles de esfuerzo, a menos que especifiques 'at').
grupo_contrast <- emmeans(modelo_4.1, 
                          pairwise ~ grupo | agent,
                          at = niveles_esfuerzo,
                          type = "response",
                          pbkrtest.limit = 5012, lmerTest.limit = 5021)

# --- Visualización de resultados ---
summary(effort_contrast)
summary(concon)
summary(agent_contrast_effort)
summary(grupo_contrast)

data_agent_effort <- as.data.frame(agent_contrast_effort$emmeans)
df_emmeans_grupo <- as.data.frame(grupo_contrast$emmeans)
ggplot(
  df_emmeans_grupo,
  aes(
    x = grupo,
    y = prob,
    color = agent,
    linetype = agent,
    group = agent
  )
) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  geom_errorbar(
    aes(ymin = asymp.LCL, ymax = asymp.UCL),
    width = 0.05
  ) +
  labs(
    x = " GRUPO",
    y = "Probabilidad predicha de decisión",
    color = "Agente",
    linetype = "Agente"
  ) +
  theme_light(base_size = 14)







